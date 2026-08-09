class_name Sujetador
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
		"Sucio": "res://Sprites/Ropa/sujetador/1k/rosa/rosa sucio.png",
		"Mojado": "res://Sprites/Ropa/sujetador/1k/rosa/rosa mojado .png",
		"Doblado": "", #TODO FALTA SUJETADOR DOBLADO
		"Normal": "res://Sprites/Ropa/sujetador/1k/rosa/rosa.png",	
	}
