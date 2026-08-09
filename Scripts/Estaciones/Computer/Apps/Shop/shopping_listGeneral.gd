extends Control

var last_button_pressed: ProductData.ProductCategory
@onready var create_list_shop = $List

func _ready() -> void:
	last_button_pressed = ProductData.ProductCategory.Electrodomestico
	set_button_signals()

func set_button_signals():
	for button in $Categories.get_children():
		button.pressed.connect(open_category_shop.bind(button.name))
	
	

func open_category_shop(category: ProductData.ProductCategory):
	last_button_pressed = category
	create_list_shop.create_shop(category)
