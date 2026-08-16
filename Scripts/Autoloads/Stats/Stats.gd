extends Node


# =========================================================
# MESES
# =========================================================

const MONTHS: Array[String] = [
	"Jan",
	"Feb",
	"Mar",
	"Apr",
	"May",
	"Jun",
	"Jul",
	"Aug",
	"Sep",
	"Oct",
	"Nov",
	"Dec"
]


# =========================================================
# ESTADÍSTICAS
# Cada posición: [Mes, Valor]
# =========================================================
var washing_machines_placed: Array[Array] = []
var stations_bought: Array[Array] = []
var money_earned: Array[Array] = []
var dryers_placed: Array[Array] = []
var clothes_ironed: Array[Array] = []
var orders_delivered: Array[Array] = []

var stats: Array[Array] = [
	washing_machines_placed,
	stations_bought,
	money_earned,
	dryers_placed,
	clothes_ironed,
	orders_delivered
]


func _ready() -> void:
	initialize_statistics()
	add_test_data()


# =========================================================
# INICIALIZAR ESTADÍSTICAS
# =========================================================

func initialize_statistics() -> void:
	for month in MONTHS:
		washing_machines_placed.append([month, 0.0])
		stations_bought.append([month, 0.0])
		money_earned.append([month, 0.0])
		dryers_placed.append([month, 0.0])
		clothes_ironed.append([month, 0.0])
		orders_delivered.append([month, 0.0])
			
func get_stats() -> Array[Dictionary]:
	var stats: Array[Dictionary] = [
		{
			"name": "Washing Machines Placed",
			"values": washing_machines_placed
		},
		{
			"name": "Stations Bought",
			"values": stations_bought
		},
		{
			"name": "Money Earned",
			"values": money_earned
		},
		{
			"name": "Dryers Placed",
			"values": dryers_placed
		},
		{
			"name": "Clothes Ironed",
			"values": clothes_ironed
		},
		{
			"name": "Orders Delivered",
			"values": orders_delivered
		}
	]

	return stats
	
# =========================================================
# DATOS DE PRUEBA
# =========================================================
func add_test_data() -> void:
	
	washing_machines_placed = [
		["Jan", 2.0],
		["Feb", 4.0],
		["Mar", 3.0],
		["Apr", 6.0],
		["May", 5.0],
		["Jun", 8.0],
		["Jul", 7.0],
		["Aug", 10.0],
		["Sep", 12.0],
		["Oct", 11.0],
		["Nov", 15.0],
		["Dec", 18.0]
	]

	stations_bought = [
		["Jan", 1.0],
		["Feb", 2.0],
		["Mar", 1.0],
		["Apr", 3.0],
		["May", 2.0],
		["Jun", 4.0],
		["Jul", 3.0],
		["Aug", 5.0],
		["Sep", 4.0],
		["Oct", 6.0],
		["Nov", 5.0],
		["Dec", 7.0]
	]

	money_earned = [
		["Jan", 500.0],
		["Feb", 750.0],
		["Mar", 620.0],
		["Apr", 1200.0],
		["May", 1500.0],
		["Jun", 2100.0],
		["Jul", 2800.0],
		["Aug", 2400.0],
		["Sep", 3500.0],
		["Oct", 4200.0],
		["Nov", 5100.0],
		["Dec", 100.0]
	]

	dryers_placed = [
		["Jan", 1.0],
		["Feb", 1.0],
		["Mar", 2.0],
		["Apr", 2.0],
		["May", 3.0],
		["Jun", 3.0],
		["Jul", 4.0],
		["Aug", 5.0],
		["Sep", 6.0],
		["Oct", 6.0],
		["Nov", 8.0],
		["Dec", 9.0]
	]

	clothes_ironed = [
		["Jan", 20.0],
		["Feb", 35.0],
		["Mar", 45.0],
		["Apr", 80.0],
		["May", 120.0],
		["Jun", 150.0],
		["Jul", 180.0],
		["Aug", 160.0],
		["Sep", 220.0],
		["Oct", 280.0],
		["Nov", 350.0],
		["Dec", 450.0]
	]

	orders_delivered = [
		["Jan", 10.0],
		["Feb", 18.0],
		["Mar", 15.0],
		["Apr", 25.0],
		["May", 35.0],
		["Jun", 48.0],
		["Jul", 60.0],
		["Aug", 55.0],
		["Sep", 75.0],
		["Oct", 90.0],
		["Nov", 110.0],
		["Dec", 140.0]
	]
