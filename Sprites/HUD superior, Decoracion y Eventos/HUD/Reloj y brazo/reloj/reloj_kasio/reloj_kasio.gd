# Reloj KASIO - dibuja la hora sobre el reloj apagado.
# Archivos en res://reloj_kasio/  (base apagada, numeros 0-9 de 20x35 y dos puntos)
extends Node2D

@export var encendido := true          # false = solo el reloj apagado
@export var usar_hora_real := true     # false = usa horas/minutos que le pase el juego
@export var horas := 10
@export var minutos := 58

const BASE := preload("res://reloj_kasio/kasio_base_apagado.png")
const NUMEROS := preload("res://reloj_kasio/kasio_numeros.png")
const DOS_PUNTOS := preload("res://reloj_kasio/kasio_dos_puntos.png")

const ANCHO := 20
const ALTO := 35
# Posiciones (px) dentro de kasio_base_apagado.png
const POS_DIGITOS := [Vector2(46, 98), Vector2(68, 98), Vector2(94, 98), Vector2(116, 98)]
const POS_DOS_PUNTOS := Vector2(90, 107)

func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST  # pixel art nitido

func _process(_delta: float) -> void:
	if usar_hora_real:
		var t := Time.get_time_dict_from_system()
		horas = t.hour
		minutos = t.minute
	queue_redraw()

# Para ponerlo a mano desde otro script: $RelojKasio.poner_hora(7, 30)
func poner_hora(h: int, m: int) -> void:
	usar_hora_real = false
	horas = clampi(h, 0, 23)
	minutos = clampi(m, 0, 59)

func _draw() -> void:
	draw_texture(BASE, Vector2.ZERO)
	if not encendido:
		return
	var cifras := [horas / 10, horas % 10, minutos / 10, minutos % 10]
	for i in 4:
		draw_texture_rect_region(NUMEROS, Rect2(POS_DIGITOS[i], Vector2(ANCHO, ALTO)),
			Rect2(cifras[i] * ANCHO, 0, ANCHO, ALTO))
	if Time.get_ticks_msec() / 500 % 2 == 0:  # los dos puntos parpadean
		draw_texture(DOS_PUNTOS, POS_DOS_PUNTOS)
