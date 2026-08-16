extends Apps

@onready var shoppingList = $Panel/App/ShoppingList
@onready var shoppingCart = $Panel/App/ShoppingCart

func toggle_minimizeWindow():
	visible = !visible
	if visible:
		shoppingList.open_category_shop(ProductData.ProductCategory.Electrodomestico)
	
