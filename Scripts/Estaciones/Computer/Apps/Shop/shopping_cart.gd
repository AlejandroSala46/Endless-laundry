extends Control

var cart: Dictionary = {}

@onready var items_container: VBoxContainer = $VScrollBar/VBoxContainer
@onready var total_label: Label = $"Total Price2"

func _ready() -> void:
	Signals.addItemToCart.connect(add_to_cart)

func add_to_cart(product: ProductData):
	if cart.has(product.id):
		cart[product.id].quantity += 1
	else:
		cart[product.id] = {
			"product": product,
			"quantity": 1
		}

	update_cart()

func update_cart():
	for child in items_container.get_children():
		child.queue_free()
	
	for item in cart.values():
		var cart_item = preload("res://Escenas/Estaciones/Computer/Apps/Shop/ProductData.tscn").instantiate()

		items_container.add_child(cart_item)

		cart_item.setup(
			item.product,
			item.quantity
		)

		cart_item.quantity_changed.connect(
			func(): _on_quantity_changed(cart_item)
		)

		cart_item.delete_requested.connect(
			func(): _on_delete_requested(cart_item)
		)

	update_total()
	
func _on_quantity_changed(cart_item):
	cart[cart_item.product.id].quantity = cart_item.quantity
	update_total()

func _on_delete_requested(cart_item):
	cart.erase(cart_item.product.id)
	cart_item.queue_free()
	update_total()

func update_total():
	var total := 0.0

	for item in cart.values():
		total += item.product.price * item.quantity

	total_label.text = "%.2f €" % total

func buy_button():
	if cart.size() > 0:
		var arrayItemsBought: Array = []

		for itemId in cart:
			var quantity = cart[itemId].quantity
			for x in quantity:
				arrayItemsBought.append(cart[itemId].product)

		cart.clear()
		update_cart()

		Signals.buyItemsCart.emit(arrayItemsBought)
	
	else:
		return
	
		
