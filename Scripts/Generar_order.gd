extends Node

var cont_OrderList 
var OrdenScene = preload("res://Escenas/Order/order.tscn")
var orden_instance


func _ready():
	randomize()
	cont_OrderList = get_node("/root/escena_principal/ListaOrdenes")

func _on_pressed() -> void:
	gen_order()
	
	
func gen_order():
	var tipo = Ropa.TipoRopa.values().pick_random()
	var new_order

	match tipo:
		Ropa.TipoRopa.PANTALON:
			new_order = Pantalon.new()
		Ropa.TipoRopa.CAMISETA:
			new_order = Camiseta.new()
		Ropa.TipoRopa.CALCETINES:
			new_order = Calcetines.new()

	# Instanciar escena UI
	var orden_ui = OrdenScene.instantiate()
	# Añadir al contenedor
	cont_OrderList.add_child(orden_ui)
	
	print(new_order.nombre)
	print(new_order.spritePath)
	# Rellenar datos en la escena
	orden_ui.set_prenda_region(
		new_order.spritePath,
		Rect2(0, 0, 313, 367)
	)

	orden_ui.set_servicios(new_order.servicios)

	
	
