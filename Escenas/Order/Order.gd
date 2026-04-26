extends Control

var texture_rect 
var servicios_container
var item_width
var item_height
var order_clothImage
var shadows_size = 8
var order

func _ready():
	
	texture_rect = get_node("OrderBorder/OrderHbox/Order_item/Order_item_sprite")
	texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	mouse_filter = Control.MOUSE_FILTER_STOP
	
	servicios_container = get_node("OrderBorder/OrderHbox/Order_requisitos")
	servicios_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func set_order(new_order, size):
	set_size_order(size)
	print("Tamaño orden creado")
	order = new_order
	set_order_image(new_order)
	print("Imagen orden añadida")
	set_order_servicios(new_order)
	print("Servicios orden creados")
	
func update_size_order(grid_width, columns, spacing):
	var item_width = (grid_width - (spacing * (columns))) / columns
	print(item_width)
	set_size_order(item_width)
	
func update_image_order(order):
	set_order_image(order)
	print("Imagen orden actualizada")

func update_servicios_order(order):
	set_order_servicios(order)
	print("Servicios orden actualizada")
	
func set_order_image(order):
	
	order_clothImage = load(order.tmp_spritePath)
	
	texture_rect.texture = order_clothImage
	texture_rect.queue_redraw()
	# 4. Confirmar asignación
	print("Texture asignada: ", texture_rect.texture)

func set_order_servicios(order):
	var ui_scale = get_viewport().size.y / 1080.0
	var font_size = int(16 * ui_scale)
	var lista = order.servicios

	for c in servicios_container.get_children():
		c.queue_free()

	for s in lista:
		var cb = CheckBox.new()
		cb.text = s
		cb.button_pressed = lista[s]
		cb.mouse_filter = Control.MOUSE_FILTER_IGNORE
		cb.add_theme_font_size_override("font_size", font_size)
		servicios_container.add_child(cb)
		
func set_size_order(item_width_inherited):
	item_width = item_width_inherited - shadows_size
	item_height = item_width/1.5
	
	custom_minimum_size = Vector2(item_width, item_height)
	texture_rect.custom_minimum_size = Vector2(item_width/2, item_height)
	servicios_container.custom_minimum_size = Vector2(item_width/2, item_height)
	
	print("Altura hijo: ", item_height)
	print("Ancho hijo: ", item_width)
	
func _get_drag_data(position):
	mouse_default_cursor_shape = Control.CURSOR_DRAG
	print("Estas intentando arrastrar algo")
	if order == null:
		return null
	
	var preview = make_preview()
	set_drag_preview(preview)
	
	return {
		"order": order,
		"ui": self
	}

func make_preview():
	var preview = Control.new()
	var size_preview = Vector2(item_width/2, item_height)
	
	preview.size = size_preview
	preview.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var tex = TextureRect.new()
	tex.texture = order_clothImage

	# tamaño del contenido
	tex.size = size_preview

	# 🔥 CENTRAR respecto al cursor
	tex.position = -size_preview / 2

	preview.add_child(tex)
	return preview

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		print("CLICK DETECTADO")
		
func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
