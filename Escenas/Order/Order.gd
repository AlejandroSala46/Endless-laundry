extends Node

var texture_rect 
var servicios_container 

func _ready():
	texture_rect = get_node("Order_item/Order_item_sprite")
	print(texture_rect)
	servicios_container = $Order_requisitos

func set_prenda_region(path, region: Rect2):
	# 1. Verificar que el path existe
	print("Path existe: ", ResourceLoader.exists(path))
			
			# 2. Verificar que carga algo
	var imagen = load(path)
	print("Imagen cargada: ", imagen)
	print("Tipo de recurso: ", imagen.get_class() if imagen else "NULL")
			
	# 3. Verificar el texture_rect
	print("texture_rect es: ", texture_rect)
	print("texture_rect visible: ", texture_rect.visible)
			
	var atlas = AtlasTexture.new()
	atlas.atlas = imagen
	atlas.region = region
	print("Region asignada: ", atlas.region)
	print("Atlas size: ", atlas.atlas.get_size() if atlas.atlas else "sin atlas")
			
	texture_rect.texture = atlas
	texture_rect.queue_redraw()
	# 4. Confirmar asignación
	print("Texture asignada: ", texture_rect.texture)


func set_servicios(lista):
	for c in servicios_container.get_children():
		c.queue_free()

	for s in lista:
		var cb = CheckBox.new()
		cb.text = s
		servicios_container.add_child(cb)
