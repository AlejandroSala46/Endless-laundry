extends Control

var texture_rectCloth 
var texture_rectOrder 
var servicios_container
var item_width
var item_height
var order_clothImage
var shadows_size = 8
var order
var prop_HeightWidth
var draggable
var orderLocationUI
@onready var orderViewPort = get_node("OrderTexture/OrderPreviewGenerator/SubViewportContainer/OrderCloth")
@onready var orderViewPortContainer = get_node("OrderTexture/OrderPreviewGenerator/SubViewportContainer")
@onready var orderPreviewContainer = get_node("OrderTexture/OrderPreviewGenerator")


func _ready():
	
	texture_rectCloth = get_node("OrderTexture/OrderPreviewGenerator/SubViewportContainer/OrderCloth/Control/ClothImage")
	print(texture_rectCloth)
	texture_rectCloth.mouse_filter = Control.MOUSE_FILTER_IGNORE
	orderPreviewContainer.resized.connect(_update_size)
	_update_size()
	texture_rectOrder = get_node("OrderTexture")
	
	mouse_filter = Control.MOUSE_FILTER_STOP
	
	servicios_container = get_node("OrderTexture/OrderPreviewGenerator/SubViewportContainer/OrderCloth/Control/VBoxContainer")
	servicios_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	prop_HeightWidth = texture_rectOrder.size.y/texture_rectOrder.size.x
	print("Proporcion: ", prop_HeightWidth)

	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	draggable = true


func set_order(new_order, slot_width, slot_height, imagePath):

	$OrderTexture/OrderNumPanel/OrderNumLabel.text = "#%s" % new_order.id
	set_size_order(slot_width, slot_height)
	print("Tamaño orden creado")
	order = new_order
	set_order_image(new_order, imagePath)
	print("Imagen orden añadida")
	set_order_servicios(new_order)
	print("Servicios orden creados")
	
func update_size_order(grid_width, columns, spacing):
	var item_width = (grid_width - (spacing * (columns))) / columns
	print(item_width)
	
func update_image_order(order, imagePath):
	set_order_image(order, imagePath)
	print("Imagen orden actualizada")

func update_servicios_order(order):
	set_order_servicios(order)
	print("Servicios orden actualizada")
	
func set_size_order(slot_width, slot_height):
	item_height = slot_height*0.97
	item_width = item_height/prop_HeightWidth
	
	custom_minimum_size = Vector2(slot_width, slot_height)
	size = Vector2(slot_width, slot_height)
	
	texture_rectOrder.custom_minimum_size = Vector2(item_width, item_height)
	
	_update_size()
	print("orderPreviewContainer: ", orderPreviewContainer.size)
	print("orderViewPortContainer: ", orderViewPortContainer.size)
	print("orderViewPort: ", orderViewPort.size)
	
	
	# texture_rectOrder.size = Vector2(item_width, item_height)
	# servicios_container.custom_minimum_size = Vector2(item_width/2, item_height)
	
func set_order_image(order, imagePath):
	
	order_clothImage = load(imagePath)
	
	texture_rectCloth.texture = order_clothImage
	texture_rectCloth.queue_redraw()
	if order.suavizada:
		print("Ropa suavizada añadiendo")
		var texSuavizada = TextureRect.new()
		var suavizada_tex = load("res://Sprites/Estaciones/Loop de Trabajo/Tablon/Tareas/suavizado.png")
		
		texSuavizada.texture = suavizada_tex
		texSuavizada.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texSuavizada.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		texSuavizada.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		texSuavizada.anchor_top = 0
		texSuavizada.anchor_left = 0.75
		texSuavizada.anchor_right = 1
		texSuavizada.anchor_bottom = 0.25
		
		texture_rectCloth.add_child(texSuavizada)
	# 4. Confirmar asignación
	print("Texture asignada: ", texture_rectCloth.texture)

func set_order_servicios(order):

	var lista = order.servicios

	for c in servicios_container.get_children():
		c.queue_free()

	for s in lista:
		print(s)
		addServicios(s, order)
		
func addServicios(servicio, order):
	var newServicioTemplate = TextureRect.new()
	
	var serviceImagePath = "res://Sprites/Estaciones/Loop de Trabajo/Tablon/Tareas/%s.png" % servicio
	var tex = load(serviceImagePath)
	if tex:
		newServicioTemplate.texture = tex
	
	newServicioTemplate.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	newServicioTemplate.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	newServicioTemplate.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	newServicioTemplate.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	if order.servicios[servicio]: 
		var tick = TextureRect.new()
		var tick_texture = load("res://Sprites/Estaciones/Loop de Trabajo/Tablon/check.png")
		
		tick.texture = tick_texture
		tick.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tick.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tick.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		tick.anchor_top = 0
		tick.anchor_left = 0
		tick.anchor_right = 1
		tick.anchor_bottom = 1
		
		newServicioTemplate.add_child(tick)
		
	servicios_container.add_child(newServicioTemplate)
	
func _get_drag_data(position):
	if !draggable:
		return null
	mouse_default_cursor_shape = Control.CURSOR_DRAG
	print("Estas intentando arrastrar algo")
	if order == null:
		return null
	
	var preview = make_preview()
	set_drag_preview(preview)
	Signals.drag_started.emit(order)
	
	return {
		"order": order,
		"ui": self,
		"previous ui": self
	}

func make_preview():
	var preview = Control.new()
	var size_preview = Vector2(item_width/2, item_height)
	
	preview.size = size_preview
	preview.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var tex = TextureRect.new()
	tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	tex.texture = order_clothImage

	# tamaño del contenido
	tex.size = size_preview

	# 🔥 CENTRAR respecto al cursor
	tex.position = -size_preview / 2

	preview.add_child(tex)
	return preview

func update_orderLocationUI(newUI):
	if newUI != null:
		orderLocationUI = newUI

func send_viewportOrder():
	var viewport = get_node("OrderTexture/OrderPreviewGenerator/SubViewportContainer/OrderCloth")
	
	viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	await RenderingServer.frame_post_draw
	
	return viewport.get_texture()

func deleteOrder(order):
	print("Llega la orden a create order new")
	var cestaOrders = get_node("/root/escena_principal/Pared/Tablero")
	cestaOrders.deleteOrderFromCesta(order)

func _update_size():
	orderViewPort.size = orderPreviewContainer.size
	orderViewPortContainer.size = orderPreviewContainer.size
	
	orderViewPortContainer.offset_left = 0
	orderViewPortContainer.offset_right = 0
	orderViewPortContainer.offset_top = 0
	orderViewPortContainer.offset_bottom = 0
	
	
