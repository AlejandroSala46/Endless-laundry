extends Control

var clothImage
var order
var order_ui
var plancha
var draggable
var clothsIn: Dictionary = {}
var clothsInArray = []
var maxItems

const CESTO_TEXTURES = {
	0: preload("res://Sprites/Estaciones/Loop de Trabajo/Entregas/Monta cargas/Estados ropa/percherocon ropa0.png"),
	1: preload("res://Sprites/Estaciones/Loop de Trabajo/Entregas/Monta cargas/Estados ropa/percherocon ropa1.png"),
	2: preload("res://Sprites/Estaciones/Loop de Trabajo/Entregas/Monta cargas/Estados ropa/percherocon ropa2.png"),
	3: preload("res://Sprites/Estaciones/Loop de Trabajo/Entregas/Monta cargas/Estados ropa/percherocon ropa3.png"),
	4: preload("res://Sprites/Estaciones/Loop de Trabajo/Entregas/Monta cargas/Estados ropa/percherocon ropa4.png"),
	5: preload("res://Sprites/Estaciones/Loop de Trabajo/Entregas/Monta cargas/Estados ropa/percherocon ropa5.png"),
	6: preload("res://Sprites/Estaciones/Loop de Trabajo/Entregas/Monta cargas/Estados ropa/percherocon ropa6.png"),
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	maxItems = 6
		

func _can_drop_data(position, data):
	return data != null # aquí puedes filtrar tipo
	
func _drop_data(position, data):
	print("Slot recibido: drop recibido")
	var previous_ui = data["previous ui"]
	var order_ui_data = data["ui"]
	var order_data = data["order"]
	
	if checks(order_ui_data, order_data): 
		print("check pasado")
		if previous_ui != order_ui_data:
			previous_ui.drop_Confirmation(order_data)
		clothsIn[order_data] = order_ui_data
		updateTexture_cesto()


func checks(order_ui, order_data) -> bool:	
	print("Mirando check")
	if maxItems > clothsIn.size():
		return true
	
	return false

func completeOrder(order, order_ui):
	await order_ui.deleteOrder(order)
	order_ui.queue_free()

func show_popup(text):
	# popup
	var popup = preload("res://Escenas/Pop ups/PopUpFinalizado.tscn").instantiate()
	get_tree().current_scene.add_child(popup)
	
	popup.show_message(text, global_position.x + size.x, global_position.y)
	
func updateTexture_cesto():
	$Tabla/Cesto.texture = CESTO_TEXTURES.get(clothsIn.size(), CESTO_TEXTURES[0])

func on_door_clicked():
	var door_button = $Door
	var animation_player = $AnimationPlayer

	door_button.disabled = true

	animation_player.play("montacargas_subiendo")
	await animation_player.animation_finished

	await get_tree().create_timer(3.0).timeout
	
	for cloth in clothsIn.keys().duplicate():
		print("Llega la orden")
		completeOrder(cloth, clothsIn[cloth])
		clothsIn.erase(cloth)
	updateTexture_cesto()
	animation_player.play("montacargas_bajando")
	await animation_player.animation_finished
	
	door_button.disabled = false
	
	
