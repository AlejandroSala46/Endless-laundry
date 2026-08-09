# Station.gd
extends Node2D
class_name Station

@export var item: ProductData
@export var widthTiles := 1
@export var depthTiles := 1
@export var typeStation := ""
@export var height := 1
@export var width := 1
@export var grid_position := Vector2i.ZERO

@onready var base_marker: Marker2D = $Sprite2D/BaseMarker
@onready var center_marker: Marker2D = $Sprite2D/CenterMarker

@export var level := 1

var is_preview := false
var is_placed := true
var can_place := true
var old_grid_position

var max_items_in := 10
var max_items_out := 10

func _process(delta):
	if is_preview and not is_placed:
		update_preview_validity()
		update_preview_position()

func get_occupied_cells() -> Array[Vector2i]:
	var cells : Array[Vector2i] = []
	
	if grid_position == Vector2i(0, 0):
		grid_position = get_grid_position()
	
	for x in range(widthTiles):
		for y in range(depthTiles):
			var cell_occupied = Vector2i(x, -y) + grid_position
			cells.append(cell_occupied)

	return cells

func set_preview_mode():
	is_preview = true

func update_preview_position():
	var mouse_pos = get_global_mouse_position()
	var offset = base_marker.global_position - center_marker.global_position
	var grid_pos = BuildManager.world_to_grid(mouse_pos + offset)
	grid_position = grid_pos
	
	# 2. VISUAL: centrar sprite en ratón
	# if can_place:
	BuildManager.preview_update_cell(get_occupied_cells(), "previewing")
	
	global_position = BuildManager.grid_to_world(grid_position) - offset
	
func update_preview_validity():
	var cells = get_occupied_cells()

	can_place = true

	for cell in cells:
		if !BuildManager.floor_tiles_status.has(cell) or BuildManager.is_cell_occupied(cell):
			can_place = false
			break


	modulate = Color(0,1,0,0.5) if can_place else Color(1,0,0,0.5)
	
func place_station():
	print("Placing")
	if is_placed:
		return

	is_preview = false
	is_placed = true
	modulate = Color(1,1,1,1)

	BuildManager.register_station(self)

func cancel_move_station():
	global_position = BuildManager.grid_to_world(old_grid_position) + get_center_offset()
	grid_position = old_grid_position
	
	place_station()

func set_base_marker():
	base_marker.global_position = global_position - Vector2(float(width/2), float(-height/2))

func get_center_offset() -> Vector2:
	return Vector2(
		width/2,
		height/2
	)

func normalize_visual():
	var tile_size = BuildManager.TILE_SIZE
	var sprite = $Sprite2D
	var size = sprite.texture.get_size()
	
	var scaleTexture = size.x/size.y
	width = float(tile_size * widthTiles)
	height = float(width/scaleTexture)

	var scale_factor = Vector2(
		 float(width / size.x),
		 float(height / size.y)
	)

	sprite.scale = scale_factor
	set_base_marker()

func building_mode():
	print("Building mode")
	if is_placed:
		is_placed = false
		old_grid_position = grid_position
		BuildManager.start_moving_station(self)
		set_preview_mode()
		
		
func _unhandled_input(event):
	if event is InputEventMouseButton and !is_placed and can_place:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("placing")
			place_station()
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			print("cancelling")
			cancel_move_station()
	
func setupTiles():
	widthTiles = 1
	depthTiles = 1

func register_station_building():
	print("Registrando: ", self.name)
	BuildManager.register_station(self)
	is_preview = false
	is_placed = true
	setup_slots(typeStation)

func updateImageStatus():
	pass
	
func setup_slots(typeStation):
	pass

func get_grid_position():
	var bottom_left = base_marker.global_position
	var startTile = BuildManager.world_to_grid(bottom_left)
	return startTile
	
func set_signals():
	Signals.building_mode_toggle.connect(buidling_mode_external)

func show_popup(text):
	# popup
	var popup = preload("res://Escenas/Pop ups/PopUpFinalizado.tscn").instantiate()
	# get_tree().current_scene.add_child(popup)
	
	# popup.show_message(text, global_position.x + size.x, global_position.y)

func buidling_mode_external(parameter: bool):
	toggle_item_pickable(parameter)
	if !parameter:
		$Sprite2D.modulate.a = 0.5
	else:
		$Sprite2D.modulate.a = 1
		
func toggle_item_pickable(parameter: bool):
	var area := $Sprite2D.get_node_or_null("Area2D")
	if area:
		area.input_pickable = parameter

func initialize(id:int, station_type:ProductData, grid_pos:Vector2i) -> void:
	if !is_node_ready():
		await ready

	setupTiles()
	normalize_visual()
	
	item = station_type
	name = "%s_%s" % [station_type.name, id]

	var base_world_pos = BuildManager.grid_to_world(grid_pos)
	var offset = Vector2(width / 2.0, -height / 2.0)

	position = base_world_pos + offset

	register_station_building()
