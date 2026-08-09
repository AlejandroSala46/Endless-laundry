class_name Calzoncillos
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
		"Sucio": "res://Sprites/Ropa/calconcillos/1k/calconcillos sucios.png",
		"Mojado": "res://Sprites/Ropa/calconcillos/1k/calconcillos mojados.png",
		"Doblado": "", #TODO FALTA CALZONCILLO DOBLADO
		"Normal": "res://Sprites/Ropa/calconcillos/1k/calconcillos.png",	
	}
