extends Node

var products: Array[ProductData] = []

func _ready():
	load_products()

func load_products():
	print("Articulos cargados")
	products.clear()

	var dir := DirAccess.open("res://Clases/ShopProducts/Electrodomesticos")
	if dir == null:
		return

	dir.list_dir_begin()

	var file := dir.get_next()
	while file != "":
		if file.ends_with(".tres"):
			var product := load("res://Clases/ShopProducts/Electrodomesticos/" + file) as ProductData
			products.append(product)

		file = dir.get_next()

	dir.list_dir_end()
	
func get_unlocked_products() -> Array[ProductData]:
	return products.filter(func(p): return p.unlocked)

func get_products_by_category(category: ProductData.ProductCategory) -> Array[ProductData]:
	return products.filter(func(p):
		return p.unlocked and p.Category == category
	)

func get_product_id(id: String) -> ProductData:
	for product in products:
		if product.id == id:
			return product
	return null

func get_product_type(type: String) -> ProductData:
	for product in products:
		if product.type == type:
			return product
	return null
