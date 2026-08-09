# Building_manager.gd
extends Node
class_name Build_manager

@export var floor_tiles_status = {}
var occupied_tilemap: TileMapLayer
var preview_tilemap: TileMapLayer
var stationMoving: Station
const TILE_SIZE = 32
const TILE_TYPES = {
	"free": {
		"id": 0,
		"atlas": Vector2i(0, 0)
	},
	"occupied": {
		"id": 2,
		"atlas": Vector2i(0, 0)
	}, 
	"previewing": {
		"id": 3,
		"atlas": Vector2i(0, 0)
	}
}

func register_station(station):
	for cell in station.get_occupied_cells():
		floor_tiles_status[cell] = true
	building_mode_toggle(true)
	stationMoving = null
	occupied_update()

func grid_to_world(cell: Vector2i) -> Vector2:
	return Vector2(
		cell.x * TILE_SIZE,
		cell.y * TILE_SIZE + TILE_SIZE
	)

func world_to_grid(pos: Vector2) -> Vector2i:
	return Vector2i(
		floor(pos.x / TILE_SIZE),
		floor(pos.y / TILE_SIZE)
	)

func place_station(station: Station):
	for cell in station.get_occupied_cells():
		floor_tiles_status[cell] = station

func occupied_update():
	occupied_tilemap.clear()
	preview_tilemap.clear()

	for cell in floor_tiles_status.keys():
		if floor_tiles_status[cell]:
			occupied_tilemap.set_cell(
				cell,
				TILE_TYPES["occupied"]["id"],
				TILE_TYPES["occupied"]["atlas"]
			)

func preview_update_cell(cells, status):
	preview_tilemap.clear()
	for cell in cells:
		preview_tilemap.set_cell(
			cell,
			TILE_TYPES[status]["id"],
			TILE_TYPES[status]["atlas"]
		)

func is_cell_occupied(cell):
	return floor_tiles_status.get(cell, false)

func start_moving_station(station: Station):
	BuildManager.building_mode_toggle(false)
	stationMoving = station
	for cell in station.get_occupied_cells():
		floor_tiles_status[cell] = false
		occupied_tilemap.set_cell(
				cell,
				TILE_TYPES["free"]["id"],
				TILE_TYPES["free"]["atlas"]
			)

func building_mode_toggle(parameter: bool):
	Signals.building_mode_toggle.emit(parameter)
	var escena = get_node("/root/escena_principal")
	
	var floorNode = escena.get_node("Floor")
	toggle_clicks_control(floorNode, parameter)
	
	var wallNode = escena.get_node("Pared")
	toggle_clicks_control(wallNode, parameter)
	
	toggle_occupiedFloorTileMap(escena, parameter)
	# toggle_clicks_control(escena, parameter)
	
func toggle_occupiedFloorTileMap(escena, parameter):
	var occupiedFloorTiles = escena.get_node("FloorTileMap/OccupiedFloorTileMap")
	occupiedFloorTiles.visible = !parameter

func toggle_clicks_control(node, parameter: bool):
	for child in node.get_children():
		if child is Area2D:
			child.input_pickable = parameter
		elif child is TextureButton or child is Button:
			child.disabled = !parameter
		elif child is Control:
			if !parameter:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE
			if parameter:
				child.mouse_filter = Control.MOUSE_FILTER_PASS
		toggle_clicks_control(child, parameter)
