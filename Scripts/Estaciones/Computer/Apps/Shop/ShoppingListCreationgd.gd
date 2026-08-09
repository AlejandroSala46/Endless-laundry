extends Panel

@onready var category_scene = preload("res://Escenas/Estaciones/Computer/Apps/Shop/ProductCategory.tscn")
@onready var product_scene = preload("res://Escenas/Estaciones/Computer/Apps/Shop/ProductCard.tscn")

func create_shop(category: ProductData.ProductCategory):

	var grouped = {}
	var products = ProductAvailableList.get_products_by_category(category)
	
	for product in products:

		if !grouped.has(product.subCategory):
			grouped[product.subCategory] = []

		grouped[product.subCategory].append(product)
	var container = $ScrollContainer/VBoxContainer

	for child in container.get_children():
		child.queue_free()
	
	for subcategory_name in grouped:
		
		var categoryEscene = category_scene.instantiate()
		container.add_child(categoryEscene)
		
		categoryEscene.set_title(ProductData.get_subcategory_name(subcategory_name))

		for product in grouped[subcategory_name]:

			var card = product_scene.instantiate()
			categoryEscene.add_product(card)
			card.setup(product)
