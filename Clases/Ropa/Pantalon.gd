class_name Pantalon
extends Ropa

var tmp_spritePath = "res://Sprites/Ropa/pantalones/pantalones.png"
func _init():
	super(TipoRopa.PANTALON, "Pantalón", tmp_spritePath)

func _init_servicios():
	servicios = {
		"lavar": false,
		"planchar": false,
		"secar": false
	}
