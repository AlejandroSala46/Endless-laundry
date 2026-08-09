extends TextureRect

var clothImage
var order
var order_ui
var plancha
var draggable
var clothsIn: Dictionary = {}
var clothsInArray = []
var maxItems

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	clothImage = null
	draggable = false
	plancha = get_node("../../..")
	visible = false
	
	maxItems = plancha.maxItems
	Signals.drag_started.connect(_on_drag_started)
	Signals.drag_ended.connect(_on_drag_ended)
	
func _can_drop_data(position, data):
	return data != null # aquí puedes filtrar tipo
	
func _drop_data(position, data):
	print("Slot recibido: drop recibido")
	var previous_ui = data["previous ui"]
	var order_ui_data = data["ui"]
	var order_data = data["order"]
	
	if checks(order_ui, order_data): 
		previous_ui.drop_Confirmation(order_data)
		order_ui_data.update_orderLocationUI(self)
		order = order_data
		order_ui = order_ui_data
		clothsIn[order] = order_ui
		clothsInArray.append(order)
		plancha.update_plancha_imagen(clothsInArray.size())
		await updateLastCloth(order_ui, order)

func updateLastCloth(order_ui, order):
	clothImage =  await order_ui.send_viewportOrder()

	$Cloth.texture = clothImage

func checks(order_ui, order_data) -> bool:
	
	if !order_data.servicios.has("planchar"):
		show_popup("La prenda no se tiene que planchar")
		return false

	if order_data.servicios["planchar"] != false:
		show_popup("La prenda ya esta planchada")
		return false
		
	if order_data.servicios["lavar"] == false:
		show_popup("La prenda no esta limpia")
		return false
	if order_data.servicios["secar"] == false:
		show_popup("La prenda no esta seca")
		return false
	if clothsIn.size() >= maxItems:
		show_popup("No caben mas items en la plancha")
		return false
	if order == order_data:
		show_popup("La prenda ya esta en el slot")
		return false
		
	return true

func send_last_clothIn():
	if clothsIn.size() > 0:
		var lastClothIn = clothsInArray[clothsInArray.size() - 1]
		return lastClothIn
	else:
		return false
	
func deleteClothIn(order):
	var order_to_delete_ui = clothsIn[order]
	clothsIn.erase(order)
	clothsInArray.erase(order)
	plancha.update_plancha_imagen(clothsInArray.size())
	if clothsInArray.size():
		var lastClothIn = clothsInArray[clothsInArray.size() - 1]
		updateLastCloth(clothsIn[lastClothIn], lastClothIn)
	else:
		$Cloth.texture = null
		_on_drag_ended(order)
	
	return order_to_delete_ui
	
func show_popup(text):
	# popup
	var popup = preload("res://Escenas/Pop ups/PopUpFinalizado.tscn").instantiate()
	get_tree().current_scene.add_child(popup)
	
	popup.show_message(text, global_position.x + size.x, global_position.y)
	
func _on_drag_started(order):
	print("Slot: Se esta arrastrando algo")
	if !visible and order.servicios["secar"] == true and order.servicios.has("planchar") and order.servicios["planchar"] == false:
		$AnimationPlayerSlotIn.play("SlotInOpen")

func _on_drag_ended(order):
	await get_tree().process_frame
	await get_tree().process_frame
	if visible and clothsInArray.size() == 0:
		$AnimationPlayerSlotIn.play("SlotInClose")
