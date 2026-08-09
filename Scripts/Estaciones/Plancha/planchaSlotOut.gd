extends TextureRect

var clothImage
var order
var order_ui
var plancha
var draggable
var clothsOut: Dictionary = {}
var clothsOutArray
var lastOrder
var maxItems

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	visible = false
	clothImage = null
	draggable = false
	plancha = get_node("../../..")
	clothsOutArray = []
	maxItems = plancha.maxItems


func updateLastCloth(order_ui, order):
	clothImage =  await order_ui.send_viewportOrder()
	$Cloth.texture = clothImage


func checks(order_ui, order_data) -> bool:
	
	if clothsOut.size() >= maxItems:
		show_popup("No caben mas items en la pila de ropa planchada")
		return false
		
	return true

func add_clothOut(new_order, new_order_ui):
	
	if checks(new_order_ui, new_order):
		clothsOut[new_order] = new_order_ui
		clothsOutArray.append(new_order)
		lastOrder = new_order
		new_order.servicios["planchar"] = true

		var imagePath = new_order.pictures["Normal"]
		new_order_ui.update_image_order(new_order, imagePath)
		new_order_ui.update_servicios_order(new_order)
		
		updateLastCloth(new_order_ui, new_order_ui)
		
		return true
	else:
		return false
		
func _get_drag_data(position):
	mouse_default_cursor_shape = Control.CURSOR_DRAG
	print("Estas intentando arrastrar algo")
	if lastOrder == null:
		return null
	
	var preview = clothsOut[lastOrder].make_preview()
	set_drag_preview(preview)
	
	return {
		"order": lastOrder,
		"ui": clothsOut[lastOrder],
		"previous ui": self
	}

func show_popup(text):
	# popup
	var popup = preload("res://Escenas/Pop ups/PopUpFinalizado.tscn").instantiate()
	get_tree().current_scene.add_child(popup)
	
	popup.show_message(text, global_position.x + size.x, global_position.y)

func drop_Confirmation(order):
	print("Drop correcto")
	clothsOut.erase(order)
	clothsOutArray.erase(order)
	
	if (clothsOutArray.size()):
		lastOrder = clothsOutArray[clothsOutArray.size() - 1]
		var lastOrder_UI = clothsOut[lastOrder]
		updateLastCloth(lastOrder_UI, lastOrder)
	
	else:
		$Cloth.texture = null
		animation_closeSlot()

func animation_openSlot():
	$AnimationPlayerSlotOut.play("SlotOutOpen")

func animation_closeSlot():
	$AnimationPlayerSlotOut.play("SlotOutClose")


	
	
	

	
