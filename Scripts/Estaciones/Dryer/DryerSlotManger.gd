extends TextureRect
var status
var clothImage
var order
var order_ui
var dryer
var draggable

@onready var dryerControl = get_node("../..")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	status = "empty"
	clothImage = null
	draggable = false
	dryer = get_node("../..")

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
		await addCloth(order, order_ui)
		start_Drying()

func _get_drag_data(position):
	if !draggable:
		return null
	mouse_default_cursor_shape = Control.CURSOR_DRAG
	print("Estas intentando arrastrar algo")
	if order == null:
		return null
	
	var preview = order_ui.make_preview()
	set_drag_preview(preview)
	Signals.drag_started.emit(order)
	
	return {
		"order": order,
		"ui": order_ui,
		"previous ui": self
	}
	
func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		print("Drag terminado (aunque no haya drop)")
		Signals.drag_ended.emit(order)

func drop_Confirmation(order):
	print("Drop correcto")
	order = null
	order_ui = null
	status = "empty"
	dryerControl.updateSlotStatus(self, status)
	
	clothImage = null
	draggable = false
	$TextureRect.texture = null
	
func addCloth(order_data, order_ui):
	clothImage = await order_ui.send_viewportOrder()
	
	$TextureRect.texture = clothImage
	status = "drying"
	dryerControl.updateSlotStatus(self, status)

func checks(order_ui, order_data) -> bool:
	
	if status != "empty":
		show_popup("Ya hay un item en este slot")
		return false

	if !order_data.servicios.has("secar"):
		show_popup("La prenda no se tiene que secar")
		return false

	if order_data.servicios["secar"] != false:
		show_popup("La prenda ya esta seca")
		return false
		
	if order_data.servicios["lavar"] == false:
		show_popup("La prenda no esta limpia")
		return false
		
	if order == order_data:
		show_popup("La prenda ya esta en el slot")
		return false
		
	return true

func start_Drying():
	$Time.visible = true
	await dryingProgressBarAnimation(15)
	
	$Time.visible = false
	# marcar como lavado
	order.servicios["secar"] = true
	var imagePath = order.pictures["Normal"]
	
	if order.servicios.has("planchar"):
		imagePath = order.pictures["Arrugado"]
	
	
	await order_ui.update_image_order(order, imagePath)
	order_ui.update_servicios_order(order)
	
	clothImage =  await order_ui.send_viewportOrder()
	$TextureRect.texture = clothImage
	status = "dryed"
	dryerControl.updateSlotStatus(self, status)
	draggable = true
	
func dryingProgressBarAnimation(time_seconds):
	var bar = $Time/ProgressBar

	bar.value = 100  # importante: empezar arriba

	var tween = create_tween()
	tween.tween_property(bar, "value", 0, time_seconds)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

	await tween.finished
	
func show_popup(text):
	# popup
	var popup = preload("res://Escenas/Pop ups/PopUpFinalizado.tscn").instantiate()
	get_tree().current_scene.add_child(popup)
	
	popup.show_message(text, global_position.x + size.x, global_position.y)

func _on_drag_started(order):
	print("Slot: Se esta arrastrando algo")
	if status == "empty" and order.servicios["lavar"] == true and order.servicios["secar"] == false:
		$AnimationPlayer.play("SlotOpen")

func _on_drag_ended():
	await get_tree().process_frame
	await get_tree().process_frame
	if status == "empty" and visible:
		$AnimationPlayer.play("SlotOff")
