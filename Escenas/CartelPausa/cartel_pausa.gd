@tool
extends Control
## Cartel colgante OPEN / CLOSED que pausa y reanuda el juego.
## Se comporta como una imagen "Keep Aspect Covered": al estirar o aplastar
## el nodo, el cartel mantiene su tamaño y solo se recortan los bordes de piedra.

signal pausa_cambiada(pausado: bool)

const BASE := Vector2(240, 216)  # tamaño de diseño de la composición
const TEX_OPEN := preload("res://Escenas/CartelPausa/cartel_open.png")
const TEX_CLOSED := preload("res://Escenas/CartelPausa/cartel_closed.png")

@onready var contenido: Control = $Contenido
@onready var placa: TextureButton = $Contenido/Placa
var pausado := false
var girando := false

func _ready() -> void:
	clip_contents = true
	_ajustar()
	if Engine.is_editor_hint():
		return
	process_mode = Node.PROCESS_MODE_ALWAYS  # sigue funcionando con el juego en pausa
	placa.pivot_offset = Vector2(placa.size.x / 2.0, 0.0)  # gira por el centro, se balancea desde arriba
	placa.pressed.connect(_on_placa_pressed)

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_ajustar()

func _ajustar() -> void:
	if contenido == null:
		return
	var s: float = max(size.x / BASE.x, size.y / BASE.y)
	contenido.scale = Vector2(s, s)
	contenido.position = (size - BASE * s) / 2.0

func _process(_delta: float) -> void:
	if Engine.is_editor_hint() or placa == null:
		return
	# oscurece la placa cuando está de canto
	var k: float = abs(placa.scale.x)
	placa.modulate = Color(1, 1, 1).lerp(Color(0.6, 0.6, 0.6), 1.0 - k)

func _on_placa_pressed() -> void:
	if girando:
		return
	girando = true
	var t := create_tween()
	t.tween_property(placa, "scale:x", 0.0, 0.15).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	t.tween_callback(_cambiar_cara)
	t.tween_property(placa, "scale:x", 1.0, 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	# pequeño balanceo al terminar
	t.tween_property(placa, "rotation", deg_to_rad(3.0), 0.08)
	t.tween_property(placa, "rotation", deg_to_rad(-2.0), 0.10)
	t.tween_property(placa, "rotation", 0.0, 0.10)
	t.tween_callback(func(): girando = false)

func _cambiar_cara() -> void:
	pausado = not pausado
	placa.texture_normal = TEX_CLOSED if pausado else TEX_OPEN
	get_tree().paused = pausado
	pausa_cambiada.emit(pausado)
