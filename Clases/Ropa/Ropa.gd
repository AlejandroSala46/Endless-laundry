class_name Ropa
extends Resource   # 👈 IMPORTANTE (mejor que Node para datos)

enum TipoRopa {
	PANTALON,
	CAMISETA,
	CALCETINES
}

var tipo: TipoRopa
var nombre: String
var spritePath: String
var servicios: Dictionary = {}  # 👈 matriz / mapa de servicios

func _init(_tipo: TipoRopa, _nombre: String, _spritePath: String):
	tipo = _tipo
	nombre = _nombre
	spritePath = _spritePath
	_init_servicios()

func _init_servicios():
	# Default (se sobreescribe en hijos)
	servicios = {
		"lavar": false,
		"planchar": false,
		"secar": false
	}
