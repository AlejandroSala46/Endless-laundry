extends Apps
@onready var statsList = $"Panel/App/Stats-Data/Resumen/Panel/VBoxContainer"
@onready var graph = $"Panel/App/Stats-Data/Resumen/Graph"
@onready var resumenButton = $Panel/App/Menu/Categories/Resumen
@onready var detallesButton = $Panel/App/Menu/Categories/Detalles
@onready var historialButton = $Panel/App/Menu/Categories/Historial
@onready var categorie_ButtonGroup := ButtonGroup.new()
@onready var stat_ButtonGroup := ButtonGroup.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scaleImage()
	categorie_ButtonGroup.allow_unpress = false
	stat_ButtonGroup.allow_unpress = false
	resumenButton.button_group = categorie_ButtonGroup
	detallesButton.button_group = categorie_ButtonGroup
	historialButton.button_group = categorie_ButtonGroup
	
	resumenButton.button_pressed = true
	on_resumen_button_pressed()


func on_resumen_button_pressed() -> void:
	
	# Limpiar botones anteriores
	for child in statsList.get_children():
		child.queue_free()

	var stats = Stats.get_stats()

	for stat in stats:
		generate_stats_button(stat)


func generate_stats_button(stat: Dictionary) -> void:
	var stat_button := Button.new()

	stat_button.name = stat["name"]
	stat_button.toggle_mode = true
	stat_button.button_group = stat_ButtonGroup
	# Tamaño horizontal completo
	stat_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	statsList.add_child(stat_button)
	
	stat_button.custom_minimum_size = Vector2(0, 100)

	# Contenedor para los dos textos
	var content := HBoxContainer.new()

	content.mouse_filter = Control.MOUSE_FILTER_IGNORE
	content.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)
	content.offset_left = 10
	content.offset_right = -10
	stat_button.add_child(content)


	# Label del nombre
	var name_label := Label.new()

	name_label.text = stat["name"]
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_label.add_theme_font_size_override("font_size", 30)

	content.add_child(name_label)


	# Label del valor total
	var value_label := Label.new()

	value_label.text = str(get_total_stat(stat["values"]))
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	value_label.add_theme_font_size_override("font_size", 30)

	content.add_child(value_label)


	# Al pulsar el botón se genera la gráfica de esta estadística
	stat_button.pressed.connect(
		graph.generate_graph.bind(stat["values"], stat["name"])
	)


func get_total_stat(values: Array) -> float:
	var total := 0.0

	for data in values:
		if data.size() >= 2:
			total += float(data[1])

	return total


func _on_detalles_pressed() -> void:
	pass # Replace with function body.


func _on_historial_pressed() -> void:
	pass # Replace with function body.
