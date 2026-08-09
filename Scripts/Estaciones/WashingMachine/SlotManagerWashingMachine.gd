extends TextureRect

@onready var washingMachineMain = $"../../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.drag_started.connect(_on_drag_started)
	Signals.drag_ended.connect(_on_drag_ended)

func _can_drop_data(position, data):
	return data != null # aquí puedes filtrar tipo

func _drop_data(position, data):
	print("LAVADORA: drop recibido")
	var previous_ui = data["previous ui"]
	var order_ui = data["ui"]
	var order_data = data["order"]
	
	if washingMachineMain.checks(order_ui, order_data):
		# guardar referencia
		await washingMachineMain.addCloth(order_data, order_ui)
		
func _get_drag_data(position):
	print("Estas intentando arrastrar algo")
	var lastOrder = washingMachineMain.lastOrder
	if lastOrder == null:
		return null
	
	var preview = washingMachineMain.clothsOnTheWashingMachine[lastOrder].make_preview()
	# set_drag_preview(preview)
	Signals.drag_started.emit(lastOrder)
	
	
	return {
		"order": washingMachineMain.lastOrder,
		"ui": washingMachineMain.clothsOnTheWashingMachine[lastOrder],
		"previous ui": self
	}

func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		print("Drag terminado (aunque no haya drop)")
		Signals.drag_ended.emit(washingMachineMain.lastOrder)

func drop_Confirmation(order):
	print("Drop correcto")
	washingMachineMain.deleteCloth(order)
	
func _on_drag_started(order):
	print("Slot: Se esta arrastrando algo")
	if  order.servicios["lavar"] == false and !washingMachineMain.washing:
		washingMachineMain.dragging = true
		play_slotAnimOpen()

func _on_drag_ended():
	if $"../../TapaAbierta".visible and !washingMachineMain.washing:
		washingMachineMain.dragging = false
		play_slotAnimClose()
		

func play_slotAnimOpen():
	$"../../TapaAbierta".visible = true
	washingMachineMain.openWashingMachineDoor()
	$"../../../AnimationPlayer".play("SlotOpen")

func play_slotAnimClose():
	$"../../TapaAbierta".visible = false
	$"../../../AnimationPlayer".play("SlotClose")
	washingMachineMain.updateImageStatus()
	
