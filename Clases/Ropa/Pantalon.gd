class_name Pantalon
extends Ropa

var tmp_spritePath = "res://Sprites/Sprite general pantalones.png"
func _init():
	super(TipoRopa.PANTALON, "Pantalón", tmp_spritePath)

func _init_servicios():
	servicios = {
		"lavar": true,
		"planchar": true,
		"secar": true
	}
