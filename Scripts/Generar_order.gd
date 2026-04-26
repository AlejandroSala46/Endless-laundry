extends Control

var gridOrders 
var OrdenScene = preload("res://Escenas/Order/order.tscn")
var orden_instance
var width
var height
var columnsGrid = 4
var spacingGrid = 10
var id_ordenes = 0

func _ready():
	randomize()
	gridOrders = get_node("/root/escena_principal/wallpaper/Menus/Orders/MenuPanel/Scroll/Grid")
	var listOrders = get_node("/root/escena_principal/wallpaper/Menus/Orders/MenuPanel/Scroll")
	
	gridOrders.columns = columnsGrid
	gridOrders.add_theme_constant_override("h_separation", spacingGrid)
	gridOrders.add_theme_constant_override("v_separation", spacingGrid)
	
	width = listOrders.size.x - 10
	height = listOrders.size.y
	
	print("Altura parent desde fuera: ", width)
	print("Ancho parent desde fuera: ", height)
	
	print("READY OK")

func _on_pressed() -> void:
	gen_order()
	
	
func gen_order():
	var tipo = Ropa.TipoRopa.values().pick_random()
	var new_order

	match tipo:
		Ropa.TipoRopa.PANTALON:
			new_order = Pantalon.new()
		Ropa.TipoRopa.CAMISETA:
			new_order = Camiseta.new()
		Ropa.TipoRopa.CALCETINES:
			new_order = Calcetines.new()

	var grid = gridOrders

	# 🔥 1. Instanciar primero
	var orden_ui = OrdenScene.instantiate()
	print("Antes de añadirla")
	grid.add_child(orden_ui)
	print("Order añadida")

	# 🔥 2. esperar a que Godot calcule layout
	await get_tree().process_frame

	# 🔥 3. ahora sí tamaño correcto
	var grid_width = width

	var item_width = (grid_width - (spacingGrid * (columnsGrid))) / columnsGrid
	var item_height = item_width/1.5
	print(item_width)
	
	orden_ui.custom_minimum_size = Vector2(item_width, item_height)
	orden_ui.size = orden_ui.custom_minimum_size

	# 🔥 4. ahora sí datos (IMPORTANTE)
	orden_ui.set_order(new_order, item_width)

	# 🔥 5. forzar layout grid
	grid.queue_sort()
	
