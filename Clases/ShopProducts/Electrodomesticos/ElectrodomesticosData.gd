class_name ProductData
extends Resource

enum ProductCategory {
	Electrodomestico,
	Consumible,
	Mueble
}
enum ProductSubCategory{
	Lavadora,
	Secadora,
	Plancha,
	Computer
}

@export var id: String
@export var name: String
@export_multiline var description: String
@export var Category: ProductCategory
@export var subCategory: ProductSubCategory
@export var scenePath: String

@export var icon: Texture2D
@export var price: float

@export var unlocked := false

static func get_subcategory_name(subcategory: ProductSubCategory) -> String:
	match subcategory:
		ProductSubCategory.Lavadora:
			return "Lavadora"
		ProductSubCategory.Secadora:
			return "Secadora"
		ProductSubCategory.Plancha:
			return "Plancha"
		ProductSubCategory.Computer:
			return "Computer"
		_:
			return "Desconocido"
