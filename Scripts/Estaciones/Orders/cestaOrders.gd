extends TextureButton

var menuOrdenes
var gridOrders 
var OrdenScene = preload("res://Escenas/Order/order.tscn")
var newOrderScene = preload("res://Escenas/Order/OrderNew.tscn")
var orden_instance
var width
var height
var columnsGrid = 5
var spacingGrid = 10
var id_ordenes = 0
var maxOrdenes = 10
var orders = {}
@onready var animation_player = $Cesto/Cesto_texture/Cloth_falling/AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Boton de ordenador listo")
	menuOrdenes = get_node("/root/escena_principal/wallpaper/Menus/Estaciones/Tablero Menu")
	
	randomize()
	gridOrders = get_node("/root/escena_principal/wallpaper/Menus/Estaciones/Tablero Menu/MenuPanel/Scroll/Grid")
	var listOrders = get_node("/root/escena_principal/wallpaper/Menus/Estaciones/Tablero Menu/MenuPanel/Scroll")
	
	gridOrders.columns = columnsGrid
	gridOrders.add_theme_constant_override("h_separation", spacingGrid)
	gridOrders.add_theme_constant_override("v_separation", spacingGrid)
	
	width = listOrders.size.x - 10
	height = listOrders.size.y

	print("Altura parent desde fuera: ", width)
	print("Ancho parent desde fuera: ", height)
	
	
	print("READY OK")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_pressed() -> void:
	print("Boton del ordenador pulsado")
	var ContenedorMenus = get_node("/root/escena_principal/wallpaper/Menus")
	
	if !menuOrdenes.visible: 
		for m in ContenedorMenus.get_children():
			m.visible = false
		menuOrdenes.visible = true
	else:
		menuOrdenes.visible = false
	print(menuOrdenes.visible)

func gen_order_check():
	if	orders.size() < maxOrdenes:
		gen_order()
		print("Orden creada")
		add_neworder_Tablero()
		
	else:
		show_popup("Limite de cesto alcanzado")

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
		Ropa.TipoRopa.SUJETADOR:
			new_order = Sujetador.new()
		Ropa.TipoRopa.CALZONCILLOS:
			new_order = Calzoncillos.new()

	var grid = gridOrders
	
	# 🔥 1. Instanciar primero
	var order_ui = newOrderScene.instantiate()
	
	print("Antes de añadirla")
	grid.add_child(order_ui)
	print("Order añadida")

	# 🔥 2. esperar a que Godot calcule layout
	await get_tree().process_frame

	# 🔥 3. ahora sí tamaño correcto
	var grid_width = width

	var item_width = (grid_width - (spacingGrid * (columnsGrid))) / columnsGrid
	# var item_height = item_width/1.5
	var item_height = height
	print(item_width)
	
	# order_ui.custom_minimum_size = Vector2(item_width, item_height)
	# order_ui.size = order_ui.custom_minimum_size
	
	var imagePath = new_order.pictures["Sucio"]
	# 🔥 4. ahora sí datos (IMPORTANTE)
	order_ui.set_order(new_order, item_width, item_height, imagePath)
	
	orders[new_order] = order_ui
	# 🔥 5. forzar layout grid
	grid.queue_sort()
	
	await playAnimationClothFalling()
	updateTextureCesto()
	
func show_popup(text):
	# popup
	var popup = preload("res://Escenas/Pop ups/PopUpFinalizado.tscn").instantiate()
	get_tree().current_scene.add_child(popup)
	
	popup.show_message(text, global_position.x + size.x, global_position.y)
	
func deleteOrderFromCesta(order):
	orders.erase(order)
	delete_order_Tablero()
	updateTextureCesto()

func updateTextureCesto():
	var cesto_TexturePath = "res://Sprites/Estaciones/Cesto/cubo animacion/cubo llenandose%s.png" % orders.size()
	
	$Cesto/Cesto_texture.texture = load(cesto_TexturePath)

func playAnimationClothFalling():
	animation_player.play("cloth_falling") # Play a quick shake on click
	
func add_neworder_Tablero():
	var grid_container = $GridContainer
	var new_order = preload("res://Escenas/Estaciones/Tablero/new_order.tscn").instantiate()

	var size_y = grid_container.size.y/2
	var size_x = grid_container.size.x /5

	print("Size y: ", size_y, " Size x: ", size_x)

	grid_container.add_child(new_order)

	# Esperar a que el nodo entre en el árbol y el layout se actualice
	await get_tree().process_frame
	
	# Aplicar tamaño
	new_order.custom_minimum_size = Vector2(size_x, size_y)
	new_order.size = Vector2(size_x, size_y)

	var animation_player_new_order = $NewOrder/AnimationPlayer
	animation_player_new_order.play("NewOrder")
	
func delete_order_Tablero():
	var grid_container = $GridContainer
	
	if grid_container.get_child_count() == 0:
		return
	
	grid_container.get_child(0).queue_free()
		
