extends Station

var wachingMachineTypes: Dictionary = {}

var clothsOnTheWashingMachine = {}
@onready var animation_player = $AnimationPlayer
var maxItems = 2
var slotsAvailable = {}
var lastOrder
var dragging
var washing
var ropaSuavizada

var randomLimitDet = 0
var randomLimitSua = 0
@onready var progress_var_detergent_Station = $Sprite2D/BarrasControl/Detergente/Fondo/Nivel
@onready var progress_var_softener_Station = $Sprite2D/BarrasControl/Suavizante/Fondo/Nivel

func _ready():
	randomize()
	availableSlots()
	set_signals()

	dragging = false
	lastOrder = null
	ropaSuavizada = false

func setupTiles():
	widthTiles = 4
	depthTiles = 3
	
func _process(delta):
	if is_preview and not is_placed:
		super._process(delta)
	
func availableSlots():
	var numSlots = 0
	
	for s in range(maxItems):
		numSlots += 1

		if slotsAvailable.size() < numSlots:
			slotsAvailable[numSlots] = null
			print("Slot añadido como disponible: ", numSlots)
		if numSlots >= maxItems:
			break

func show_popup(text):
	# popup
	var popup = preload("res://Escenas/Pop ups/PopUpFinalizado.tscn").instantiate()
	get_tree().current_scene.add_child(popup)
	
	popup.show_message(text, 0, 0)

func addCloth(order_data, order_ui):
	
	clothsOnTheWashingMachine[order_data] = order_ui
	order_ui.update_orderLocationUI(self)
	order_ui.draggable = false
	for s in slotsAvailable:
		if slotsAvailable[s] == null:
			slotsAvailable[s] = order_data
			updateLastItem()
			updateImageStatus()
			break

func deleteCloth(order):
	print("Drop correcto")
	clothsOnTheWashingMachine.erase(order)
	
	for s in slotsAvailable.keys():
		if slotsAvailable[s] == order:
			slotsAvailable[s] = null
	updateLastItem()
	updateImageStatus()

func updateLastItem():
	var valid_orders = slotsAvailable.values().filter(
		func(v): return v != null
	)
	var texture = $Sprite2D/SlotControl/Slot1/Cloth
	if !valid_orders.is_empty():
		print(valid_orders.size())
		lastOrder = valid_orders[-1]

		print(lastOrder.id)

		var lastOrder_ui = clothsOnTheWashingMachine[lastOrder]
		
		var image = await lastOrder_ui.send_viewportOrder()
		
		texture.texture = image
		randomLimitDet = updateRandomLimit()
		randomLimitSua = updateRandomLimit()
	else:
		print("Vacio")
		lastOrder = null
		texture.texture = null
		randomLimitDet = 0
		randomLimitSua = 0
		
	
	$Sprite2D/SlotControl/Slot1/Label.text = str(valid_orders.size())

func updateRandomLimit():
	var maxClothsOnWashingMachine = clothsOnTheWashingMachine.size()
	var slotsAvailable = slotsAvailable.size()
	
	var maximumPercentagePerBlock = (maxClothsOnWashingMachine *100)/ slotsAvailable

	var minimumPercentagePerBlock = maximumPercentagePerBlock - 100/slotsAvailable
	
	
	var randomLimit = randi_range(minimumPercentagePerBlock, maximumPercentagePerBlock)
	
	return randomLimit
	
func checks(order_ui, order_data) -> bool:
	
	if clothsOnTheWashingMachine.size() >= maxItems:
		show_popup("No caben mas items en la lavadora")
		return false

	if !order_data.servicios.has("lavar"):
		show_popup("La prenda no se tiene que lavar")
		return false

	if order_data.servicios["lavar"] != false:
		show_popup("La prenda ya esta lavada")
		return false
		
	if clothsOnTheWashingMachine.has(order_data):
		show_popup("La prenda ya esta en la lavadora")
		return false
		
	return true

func updateClothWashedStatus():
	for s in slotsAvailable:
		if slotsAvailable[s] == null:
			continue
		
		var order = slotsAvailable[s]
		var ui = clothsOnTheWashingMachine[order]
		
		if ropaSuavizada:
			order.suavizada = true
		# marcar como lavado
		order.servicios["lavar"] = true

		var imagePath = order.pictures["Mojado"]
		ui.update_image_order(order, imagePath)
		ui.update_servicios_order(order)

func updateProgressVarStation(progress_bar_detergent, progress_bar_softener):

	progress_var_detergent_Station.value = progress_bar_detergent
	progress_var_softener_Station.value = progress_bar_softener

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("click")
			Signals.washingMachine_OpenMenu.emit(self)

func updateImageStatus():
	
	var numCloths = clothsOnTheWashingMachine.size()
	var path = (
				"res://Sprites/Estaciones/Loop de Trabajo/Lavadora/lavadora llenandose/cerrada/lavadora tapadera cerrada%s.png" %
				numCloths
				)
	$Sprite2D.texture = load(path)
	
func openWashingMachineDoor():
	var numCloths = clothsOnTheWashingMachine.size()
	var path = (
				"res://Sprites/Estaciones/Loop de Trabajo/Lavadora/lavadora llenandose/abierta/lavadora tapadera abierta%s.png" %
				numCloths
				)
	$Sprite2D.texture = load(path)
	$Sprite2D/TapaAbierta.visible

func proceso_lavado(checkLavada, checkSuavizada):
	washing = true
	animation_player.play("washingMachine") # Play a quick shake on click
	await get_tree().create_timer(3.0).timeout
	washing = false
	if checkLavada:
		if checkSuavizada:
			ropaSuavizada = true
		updateClothWashedStatus()
	else:
		show_popup("Lavadadora finalizada con menos detergent")

	updateLastItem()
	updateProgressVarStation(0, 0)

func _on_area_2d_mouse_entered() -> void:
	if !dragging and !washing:
		$Sprite2D/SlotControl/Slot1.play_slotAnimOpen()

func _on_area_2d_mouse_exited() -> void:
	if !dragging and !washing:
		$Sprite2D/SlotControl/Slot1.play_slotAnimClose()
