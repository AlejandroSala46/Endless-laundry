extends HBoxContainer

signal quantity_changed
signal delete_requested

var product: ProductData
var quantity: int = 1

@onready var icon: TextureRect = $Item/Icon
@onready var name_label: Label = $Item/ItemName
@onready var price_label: Label = $Price/PriceLabel

@onready var quantity_label: SpinBox = $Quantity/SpinBox
@onready var total_label: Label = $TotalPrice/TotalPriceLabel




func setup(product_data: ProductData, amount: int = 1):
	product = product_data
	quantity = amount
	
	icon.texture = product.icon
	name_label.text = product.name
	price_label.text = "%.2f €" % product.price
	quantity_label.value = quantity
	
	update_ui()


func update_ui():
	total_label.text = "%.2f €" % (product.price * quantity_label.value)


func _on_spin_box_value_changed(value: float) -> void:
	if quantity_label.value > 1:
		update_ui()
		quantity_changed.emit()
	else:
		delete_requested.emit()
