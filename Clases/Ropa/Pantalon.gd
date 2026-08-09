class_name Pantalon
extends Ropa

var tmp_spritePath = "res://Sprites/Ropa/pantalones/pantalones.png"

func _init():
	super(TipoRopa.PANTALON, "Pantalón", tmp_spritePath, false)

func _init_servicios():
	servicios = {
		"lavar": false,
		"planchar": false,
		"secar": false
	}
	
func _init_pictures():
	# Default
	pictures = {
		"Sucio": "res://Sprites/Ropa/pantalones/1k/pantalones sucios.png",
		"Mojado": "res://Sprites/Ropa/pantalones/1k/pantalones mojados.png",
		"Arrugado": "res://Sprites/Ropa/pantalones/1k/pantalones arrugados.png",
		"Doblado": "res://Sprites/Ropa/pantalones/1k/pantalones doblados.png",
		"Normal": "res://Sprites/Ropa/pantalones/1k/pantalones.png",	
	}
