class_name Camiseta
extends Ropa

var tmp_spritePath = "res://Sprites/Ropa/polo/polo rojo/camiseta polo roja.png"

func _init():
	super(TipoRopa.CAMISETA, "Camiseta", tmp_spritePath)

func _init_servicios():
	servicios = {
		"lavar": false,
		"planchar": false,
		"secar": false
	}
