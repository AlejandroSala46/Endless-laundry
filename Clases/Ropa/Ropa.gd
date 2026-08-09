class_name Ropa
extends Resource   # 👈 IMPORTANTE (mejor que Node para datos)

static var NEXT_ID = 1

enum TipoRopa {
	PANTALON,
	CAMISETA,
	CALCETINES,
	SUJETADOR,
	CALZONCILLOS
}

var id: int
var tipo: TipoRopa
var nombre: String
var spritePath: String
var servicios: Dictionary = {}  # 👈 matriz / mapa de servicios
var pictures: Dictionary = {}
var states_by_service: Dictionary = {}
var suavizada
var multVersionsBool
var version

func _init(_tipo: TipoRopa, _nombre: String, _spritePath: String, _multVersionsBool):
	randomize()
	id = NEXT_ID
	NEXT_ID += 1
	tipo = _tipo
	nombre = _nombre
	spritePath = _spritePath
	suavizada = false
	if _multVersionsBool:
		multVersionsBool = _multVersionsBool
		var multVersions = _init_different_versions()
		
		if multVersions.size() > 0:
			version = multVersions.pick_random()
		
	_init_servicios()
	_init_pictures()
	_init_states_by_service()
	
func _init_servicios():
	# Default (se sobreescribe en hijos)
	servicios = {
		"lavar": false,
		"secar": false,
		"planchar": false
	}
	
func _init_pictures():
	# Default
	pictures = {
		"Sucio": "",
		"Mojado": "",
		"Doblado": "",
		"Normal": "",	
	}

func _init_states_by_service():
	states_by_service = {
		"lavar": "Mojado",
		"secar": "Normal",
		"planchar": "Doblado"
	}

func _init_different_versions():
	return
