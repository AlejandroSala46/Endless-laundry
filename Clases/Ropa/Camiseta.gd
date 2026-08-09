class_name Camiseta
extends Ropa

var tmp_spritePath = "res://Sprites/Ropa/polo/polo rojo/camiseta polo roja.png"

func _init():
	super(TipoRopa.CAMISETA, "Camiseta", tmp_spritePath, true)

func _init_servicios():
	servicios = {
		"lavar": false,
		"planchar": false,
		"secar": false
	}
func _init_pictures():
	pictures = {
		"Sucio": "res://Sprites/Ropa/polo/1k/%s/%s sucio.png" % [version, version],
		"Mojado": "res://Sprites/Ropa/polo/1k/%s/%s mojado.png" % [version, version],
		"Arrugado": "res://Sprites/Ropa/polo/1k/%s/%s arrugado.png" % [version, version],
		"Doblado": "res://Sprites/Ropa/polo/1k/%s/%s doblado.png" % [version, version],
		"Normal": "res://Sprites/Ropa/polo/1k/%s/%s.png" % [version, version],
	}

func _init_different_versions():
	return [
		"azul",
		"rojo",
		"rosa",
		"verde"
	]
