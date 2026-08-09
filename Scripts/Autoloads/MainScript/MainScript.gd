extends Control

var stations: Dictionary = {}
var idStation := 0

enum StionTypes {
	WashingMachine,
	Dryer,
	Plancha,
	Computer
}
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.create_new_station.connect(add_station_buldingMode)
	# startStationDryer()
	# startStationPlancha()
	set_highlight_tilemap()
	set_floor_tiles_array()
	MouseCursor.setDefaultMouseImages()
	
	var lavadora: ProductData = load("res://Clases/ShopProducts/Electrodomesticos/Lavadora.tres")
	var secadora: ProductData = load("res://Clases/ShopProducts/Electrodomesticos/Secadora.tres")
	var plancha: ProductData = load("res://Clases/ShopProducts/Electrodomesticos/Plancha.tres")
	var computer: ProductData = load("res://Clases/ShopProducts/Electrodomesticos/computer.tres")

	await start_stations(lavadora, 10, 2)
	await start_stations(secadora, 16, 1)
	await start_stations(plancha, 25, 1)
	await start_stations(computer, 0, 3)
	
	for b in $Paneles.get_children():
		if b is Button:
			b.pressed.connect(
				func():
					add_station_button(b.name)
			)
	
	
	Signals.world_initializated.emit()
	
func set_highlight_tilemap():
	BuildManager.occupied_tilemap = $FloorTileMap/OccupiedFloorTileMap
	BuildManager.preview_tilemap = $FloorTileMap/PreviewFloorTileMap
	
func set_floor_tiles_array():
	var floor_tileMap: TileMapLayer = $FloorTileMap

	for cell in floor_tileMap.get_used_cells():
		var source_id = floor_tileMap.get_cell_source_id(cell)
		
		# Si la celda tiene tile (no está vacía)
		if source_id > 1:
			BuildManager.floor_tiles_status[cell] = true
		elif source_id != -1:
			BuildManager.floor_tiles_status[cell] = false

func start_stations(station_type: ProductData, grid_x, grid_y):
	var estacionesNode = $Floor/Estaciones
	
	var scene_path = station_type.scenePath
	var new_station = load(scene_path).instantiate()
	estacionesNode.add_child(new_station)
	
	print("Añadiendo ", station_type)
	
	idStation += 1
	await new_station.initialize(
		idStation,
		station_type,
		Vector2i(grid_x, grid_y)
	)
	
	add_stationDictionary(idStation, station_type, new_station)

func add_stationDictionary(id, StationType, instance):
	stations[id] = {
		"StationType": StationType,
		"Instance": instance,
	}
	
func add_station_buldingMode(stationProduct: ProductData): 
	print("Creando estacion ", stationProduct)
	
	await start_stations(stationProduct, -10, -10)
	
	var station = stations[idStation]["Instance"]
	station.building_mode()
	
	

func add_station_button(type):
	print("Creando estacion ", type)
	if type == "Button":
		return
	var lavadora: ProductData = load("res://Clases/ShopProducts/Electrodomesticos/Lavadora.tres")
	await start_stations(lavadora, -10, -10)
	
	var station = stations[idStation]["Instance"]
	
	station.building_mode()
	

	
