extends Panel

signal quantity_changed
signal delete_requested

var product: ProductData
var quantity: int = 1

@onready var icon: TextureRect = $Control/Icon
@onready var name_label: Label = $Control/ItemName
@onready var price_label: Label = $Control/Price

@onready var quantity_label: Label = $Control/QuantityLabel
@onready var total_label: Label = $Control/TotalPrice

@onready var minus_button: Button = $Control/ButtonMinus
@onready var plus_button: Button = $Control/ButtonPlus


func setup(product_data: ProductData, amount: int = 1):
	product = product_data
	quantity = amount
	
	icon.texture = product.icon
	name_label.text = product.name
	price_label.text = "%.2f €" % product.price
	
	update_ui()


func update_ui():
	quantity_label.text = str(quantity)
	total_label.text = "%.2f €" % (product.price * quantity)


func _on_plus_button_pressed():
	quantity += 1
	update_ui()
	quantity_changed.emit()


func _on_minus_button_pressed():
	if quantity > 1:
		quantity -= 1
		update_ui()
		quantity_changed.emit()
	else:
		delete_requested.emit()
