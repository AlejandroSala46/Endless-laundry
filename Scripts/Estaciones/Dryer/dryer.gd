extends Station


var clothsOnTheDryer = {}
# @onready var animation_player = $AnimationPlayer
var maxItems = 2
var slotsAvailable = {}
var dryer_types_data = {}
@onready var animationPlayer = $Sprite2D/AspectRatioContainer/Ventilador/AnimationPlayer

func _ready():
	widthTiles = 4
	depthTiles = 2

	setup_dryer_types_data()
	typeStation = "small"
	await updateImageStatus()
	set_signals()

func _process(delta):
	if is_preview and not is_placed:
		super._process(delta)

func setupTiles():
	widthTiles = 5
	depthTiles = 2

func show_popup(text):
	# popup
	var popup = preload("res://Escenas/Pop ups/PopUpFinalizado.tscn").instantiate()
	get_tree().current_scene.add_child(popup)
	
	popup.show_message(text, 0)
	
func setup_slots(typeStation):
	var data = dryer_types_data[typeStation]
	var slotsControl = Control.new()
	add_child(slotsControl)
	
	slotsControl.position = Vector2(-width / 2, -height / 2 - 30)
	slotsControl.size = Vector2(width,40)
	
	print(slotsControl.global_position)
	for anchor_data in data.slots:
		var slot = preload("res://Escenas/Estaciones/Dryer/DryerSlot.tscn").instantiate()
		
		slot.anchor_left = anchor_data.x
		slot.anchor_top = anchor_data.y
		slot.anchor_right = anchor_data.z
		slot.anchor_bottom = anchor_data.w
		slot.visible = false
		slotsControl.add_child(slot)
		
		slotsAvailable[slot] = "empty"
	
func setup_dryer_types_data():
		dryer_types_data = {
			"small": {
				"fullStatus": [
					"res://Sprites/Estaciones/Loop de Trabajo/Tendedero/estados/Tendedero simple/tendedero simple vacio.png",
					"res://Sprites/Estaciones/Loop de Trabajo/Tendedero/estados/Tendedero simple/tendedero simple lleno.png"
				],
				"slots": [
					Vector4(0.25, 0, 0.45, 1),
					Vector4(0.55, 0, 0.75, 1)
				]
			},
		
		"large": {
			"texture": "res://large.png",
			"slots": [
				Vector2(40, 20),
				Vector2(100, 20),
				Vector2(160, 20),
				Vector2(220, 20)
			]
		}
	}

func updateSlotStatus(slot, status):
	slotsAvailable[slot] = status
	print("Slot status change: ", status)
	updateImageStatus()
	updateAnimation()
	
func updateAnimation():
	if slotsAvailable.values().has("drying"):
		if !animationPlayer.is_playing():
			animationPlayer.play("ventiladorOn")
			print(animationPlayer.current_animation)
			await animationPlayer.animation_finished
			animationPlayer.play("ventilador") # Teoricamente no deberia de parar
			print(animationPlayer.current_animation)
			print(animationPlayer.is_playing())
	else:
		animationPlayer.play("VentiladorOff")

func updateImageStatus():

	var status = dryer_types_data[typeStation].fullStatus
	if status.is_empty():
		return

	var total_slots = slotsAvailable.size()
	if total_slots == 0:
		$Sprite2D.texture = load(status[0])

	var emptySlots = 0

	for s in slotsAvailable.values():
		if s == "empty":
			emptySlots += 1
	print("emptySlots: ", emptySlots)
	print("total_slots: ", total_slots)
	var porc = 1 - float(emptySlots) / float(total_slots)
	
	var index = int(floor(porc * status.size()))
	print("porc: ", porc)
	index = clamp(index, 0, status.size() - 1)
	
	print("Imagen num: ", index)

	$Sprite2D.texture = load(status[index])


	
	
	
	

	
