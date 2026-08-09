extends Control
@onready var hBoxContainer: HBoxContainer = $Fondo/ScrollContainer/HBoxContainer
@onready var inventoryRack: TextureRect = $Fondo
var inventoryArray: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.deleteFromInventory.connect(deleteItemInventory)

func addItemInventory(item: ProductData):
	var newItemScene = load("res://Escenas/Inventario/ItemInventori.tscn").instantiate()
	print("Añadiendo item :", item.name)
	hBoxContainer.add_child(newItemScene)

	newItemScene.changeItemIcon(item)
	inventoryArray[newItemScene] = item
	
		

func deleteItemInventory(itemInstance):
	inventoryArray.erase(itemInstance)
	toggle_showInventory()
	itemInstance.queue_free()

func onInventoryButtonClick():
	if BuildManager.stationMoving == null:
		toggle_showInventory()
	else:
		var station = BuildManager.stationMoving
		addItemInventory(station.item)
		station.queue_free()
		BuildManager.stationMoving = null
		
func toggle_showInventory():
	inventoryRack.visible = !inventoryRack.visible
