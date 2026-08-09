class_name Calcetines
extends Ropa

var tmp_spritePath = "res://Sprites/Ropa/calcetines/calcetines blancos.png"

func _init():
	super(TipoRopa.CALCETINES, "Calcetines", tmp_spritePath, false)

func _init_servicios():
	servicios = {
		"lavar": false,
		"secar": false
	}

func _init_pictures():
	# Default
	pictures = {
		"Sucio": "res://Sprites/Ropa/calcetines/calcetines blancos sucios.png",
		"Mojado": "res://Sprites/Ropa/calcetines/calcetines blancos mojados.png",
		"Doblado": "res://Sprites/Ropa/calcetines/calcetines blancos doblados.png",
		"Normal": "res://Sprites/Ropa/calcetines/calcetines blancos.png",	
	}
