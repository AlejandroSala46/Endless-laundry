extends Control

# var OrdenScene = preload("res://Escenas/Order/order.tscn")
var gridToClean
var gridCleaned
var scrollToClean
var columnsGrid = 2
var spacingGrid = 10
var width
var height
var clothsOnTheWashingMachine = {}
@onready var animation_player = $AnimationPlayer

func _ready():
	randomize()
	gridToClean = get_node("/root/escena_principal/wallpaper/Menus/Lavadora/MenuPanel/PanelToClean/Scroll/Grid")
	gridCleaned = get_node("/root/escena_principal/wallpaper/Menus/Lavadora/MenuPanel/PanelCleaned/Scroll/Grid")
	scrollToClean = get_node("/root/escena_principal/wallpaper/Menus/Lavadora/MenuPanel/PanelToClean/Scroll")
	
	gridToClean.columns = columnsGrid
	gridToClean.add_theme_constant_override("h_separation", spacingGrid)
	gridToClean.add_theme_constant_override("v_separation", spacingGrid)
	
	gridCleaned.columns = columnsGrid
	gridCleaned.add_theme_constant_override("h_separation", spacingGrid)
	gridCleaned.add_theme_constant_override("v_separation", spacingGrid)
	
	width = scrollToClean.size.x - 10
	height = scrollToClean.size.y
	
	print("LAVADORA: Altura parent desde fuera: ", width)
	print("LAVADORA: Ancho parent desde fuera: ", height)


func _can_drop_data(position, data):
	return data != null # aquí puedes filtrar tipo
	
func _drop_data(position, data):
	print("LAVADORA: drop recibido")
	var order_ui = data["ui"]
	var order_data = data["order"]
	
	print("LAVADORA: lavar=", order_data.servicios["lavar"])
	if order_data.servicios.has("lavar"):
		print("LAVADORA: la orden tiene que lavarse")
		if order_data.servicios["lavar"] == false and order_ui.get_parent() != gridToClean:
			print("LAVADORA: ha entrado en la lavadora")
			# 🔥 mover UI directamente
			move_ui(order_ui, gridToClean)
			# guardar referencia
			
			clothsOnTheWashingMachine[order_data] = order_ui

func _on_pressed() -> void:
	var ContenedorMenus = get_node("/root/escena_principal/wallpaper/Menus")
	var menuLavadora = get_node("/root/escena_principal/wallpaper/Menus/Lavadora")
	
	if !menuLavadora.visible: 
		for m in ContenedorMenus.get_children():
			m.visible = false
		menuLavadora.visible = true
	else:
		menuLavadora.visible = false
	print(menuLavadora.visible)


func _on_on_off_pressed() -> void:
	await proceso_lavado()

	for order in clothsOnTheWashingMachine:
		var ui = clothsOnTheWashingMachine[order]

		# marcar como lavado
		order.servicios["lavar"] = true

		# 🔥 mover UI directamente
		move_ui(ui, gridCleaned)
		ui.update_servicios_order(order)

	clothsOnTheWashingMachine.clear()

	# popup
	var popup = preload("res://Escenas/Pop ups/PopUpFinalizado.tscn").instantiate()
	get_tree().current_scene.add_child(popup)
	popup.show_message("Lavadora Finalizada")

func proceso_lavado():
	animation_player.play("washingMachine") # Play a quick shake on click
	await get_tree().create_timer(3.0).timeout
	print("Se ha lavado")
	return

func move_ui(ui, target_grid):
	if ui.get_parent():
		ui.get_parent().remove_child(ui)
	target_grid.add_child(ui)
	ui.update_size_order(width, columnsGrid, spacingGrid)
	target_grid.queue_sort()
	
