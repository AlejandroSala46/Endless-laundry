extends Station

var maxItems = 10

@onready var slotIn = get_node("Sprite2D/AspectRatioContainerIn/SlotIn")
@onready var slotOut = get_node("Sprite2D/AspectRatioContainerOut/SlotOut")

var planchaType




var tiles_occupied: Vector2i
func _ready():
	widthTiles = 7
	depthTiles = 2
	planchaType = setPlanchaType()
	
	maxItems = planchaType["maxItemsIn"]
	
	set_signals()

func setupTiles():
	widthTiles = 6
	depthTiles = 2

func _process(delta):
	if is_preview and not is_placed:
		super._process(delta)

func openMenu_iron():
	print("click")
	Signals.iron_OpenMenu.emit(self)

func send_last_clothIn():
	return slotIn.send_last_clothIn()

func cloth_done(order):
	var order_ui = slotIn.deleteClothIn(order)
	
	if order_ui != null:
		if slotOut.add_clothOut(order, order_ui):
			return true

	return false
		
func setPlanchaType(): 
	return {
		"imagenes": [
			"res://Sprites/Estaciones/plancha/estados/articulos separados/tabla de planchar vacia.png",
			"res://Sprites/Estaciones/plancha/estados/tabla de planchar medio llena sin plancha.png",
			"res://Sprites/Estaciones/plancha/estados/tabla de planchar llena sin plancha.png",
		],
		"maxItemsIn": 10,
		"maxItemsOut": 10
	}
	
func update_plancha_imagen(itemsIn):
	updateanimation_Arrow(itemsIn)
	var status = planchaType["imagenes"]
	if status.is_empty():
		return
	var porc = float(itemsIn) / float(maxItems)
	
	var index = int(floor(porc * status.size()))
	print("PLANCHA: porc: ", porc)
	index = clamp(index, 0, status.size() - 1)
	
	print("PLANCHA: Imagen num: ", index)

	# texture = load(status[index])	
	
func updateanimation_Arrow(itemsIn):
	if itemsIn > 0 and !$Sprite2D/Arrow.visible:
		$Sprite2D/Arrow.visible = true
		
		$Sprite2D/Arrow/AnimationPlayerArrow.play("FlechaMov")
		slotOut.animation_openSlot()
	
	if itemsIn == 0 and $Sprite2D/Arrow.visible:
		$Sprite2D/Arrow/AnimationPlayerArrow.stop()
		$Sprite2D/Arrow.visible = false	
	
