extends Button

@onready var image = $VBoxContainer/Icon
@onready var name_label = $VBoxContainer/Name
@onready var price_label = $VBoxContainer/Price

var product

func setup(data):
	product = data

	image.texture = data.icon
	name_label.text = data.name
	price_label.text = "$%.2f" % data.price

func addItemToCart():
	Signals.addItemToCart.emit(product)
