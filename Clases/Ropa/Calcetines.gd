class_name Calcetines
extends Ropa

var tmp_spritePath = "res://Sprites/Ropa/calcetines/calcetines blancos.png"

func _init():
	super(TipoRopa.CALCETINES, "Calcetines", tmp_spritePath)

func _init_servicios():
	servicios = {
		"lavar": false,
		"secar": false
	}
