extends Control

@onready var shoppingList = $Panel/App/ShoppingList
@onready var shoppingCart = $Panel/App/ShoppingCart

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale = Vector2(size.x/1920, size.y/1080)
	size = Vector2(1920, 1080)


func toggle_minimizeWindow():
	visible = !visible
	if visible:
		shoppingList.open_category_shop(ProductData.ProductCategory.Electrodomestico)

func closeWindow():
	Signals.closeWindow.emit(self)
	
