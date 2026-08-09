extends Control

@onready var node_NormalTexture = get_node("Cloth/ClothNormal")
@onready var node_ArrugadaTexture = get_node("Cloth/ClothArrugada")
@onready var iron_cursor = get_node("Mouse")
@onready var progressBar = get_node("ProgressBar")
@onready var animation_player_cloth = get_node("Cloth/ClothArrugada/AnimationPlayer")

var clothToClean_order
var stationUI
var miniGameOn
var progress
var last_mouse_pos
var iron_mask: Image
var brush_size
var imageArrugada: Image
var textureArrugada: ImageTexture
var transparent_pixels
var total_pixels
var cloth_tex_size: Vector2
var cloth_displayed_size: Vector2
var cloth_offset: Vector2
var popup_toggle
var gettingOrder

func _ready() -> void:
	print("Menu plancha ready")
	Signals.iron_OpenMenu.connect(openMenu)
	miniGameOn = false
	transparent_pixels = 0
	total_pixels = 0
	last_mouse_pos = Vector2.ZERO
	progress = 0
	iron_mask = iron_cursor.texture.get_image()
	gettingOrder = false

func openMenu(stationUI_receiver):
	print("click detectado")
	reset_values_minigame()
	miniGameOn = false
	stationUI = stationUI_receiver
	visible = true

func getOrdersSlotIn():
	var clothToClean = stationUI.send_last_clothIn()
	if clothToClean:
		print("Entra dentro")
		clothToClean_order = clothToClean
		return true
	else:
		return false

func loadClothsTextures():

	node_ArrugadaTexture.modulate = Color(1.0, 1.0, 0.8)

	var texture_clothArrugada = load(clothToClean_order.pictures["Arrugado"])
	var texture_clothNormal = load(clothToClean_order.pictures["Normal"])

	node_NormalTexture.texture = texture_clothNormal

	imageArrugada = texture_clothArrugada.get_image().duplicate()

	get_totalPixels(imageArrugada)

	textureArrugada = ImageTexture.create_from_image(imageArrugada)

	node_ArrugadaTexture.texture = textureArrugada

	# PRECALCULAR DATOS
	cloth_tex_size = textureArrugada.get_size()

	var rect_size = node_ArrugadaTexture.size

	var scale = min(
		rect_size.x / cloth_tex_size.x,
		rect_size.y / cloth_tex_size.y
	)

	cloth_displayed_size = cloth_tex_size * scale
	cloth_offset = (rect_size - cloth_displayed_size) / 2.0

	animation_player_cloth.play("fade_in")

func _notification(what):
	if what == NOTIFICATION_VISIBILITY_CHANGED:
		print("Visible:", visible)
		print_stack()

func _process(delta):
	if stationUI != null and !miniGameOn and !gettingOrder and visible:
		get_nextOrder()
		
	if miniGameOn and progress >= 0.8:
		if stationUI.cloth_done(clothToClean_order):
			miniGameOn = false
			reset_values_minigame()
	if miniGameOn and imageArrugada != null:
		updateMiniGame()
	
	if visible:
		if !iron_cursor.visible:
			enable_plancha_cursor()
		update_plancha_cursor_pos()
	else:
		stationUI = null
		if iron_cursor.visible:
			disable_plancha_cursor()

func get_nextOrder():
	gettingOrder = true
	if getOrdersSlotIn():
		loadClothsTextures()
		miniGameOn = true
		popup_toggle = false
	elif !popup_toggle:
		stationUI.show_popup("No hay mas prendas que planchar")
		popup_toggle = true
	
	gettingOrder = false

func updateMiniGame():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			var mouse_pos = node_ArrugadaTexture.get_local_mouse_position()
			
			# Posición relativa dentro de la imagen visible
			var local_pos = mouse_pos - cloth_offset

			# Ignorar si está fuera
			if local_pos.x < 0 or local_pos.y < 0:
				return

			if local_pos.x > cloth_displayed_size.x or local_pos.y > cloth_displayed_size.y:
				return

			# Convertir a píxeles reales
			var pos = Vector2(
				local_pos.x / cloth_displayed_size.x * cloth_tex_size.x,
				local_pos.y / cloth_displayed_size.y * cloth_tex_size.y
			)

			erase_iron(pos)
			
			progress = float(transparent_pixels) / float(total_pixels)
			progressBar.value = float((progress*100)/0.8)

func reset_values_minigame():
	progress = 0
	total_pixels = 0
	transparent_pixels = 0
	gettingOrder = false
	
	node_NormalTexture.texture = null
	node_NormalTexture.queue_redraw()
	
	node_ArrugadaTexture.texture = null
	node_ArrugadaTexture.queue_redraw()
	animation_player_cloth.play("RESET")
	progressBar.value = 0

func erase_iron(pos: Vector2):
	var tex = iron_cursor.texture

	if tex == null:
		return

	var mask = iron_mask

	var visual_w = int(iron_cursor.size.x)
	var visual_h = int(iron_cursor.size.y)

	var img_w = imageArrugada.get_width()
	var img_h = imageArrugada.get_height()

	for x in range(visual_w):
		for y in range(visual_h):

			# Convertimos coordenadas visuales a coordenadas de la textura
			var mask_x = int(float(x) / visual_w * mask.get_width())
			var mask_y = int(float(y) / visual_h * mask.get_height())

			var mask_pixel = mask.get_pixel(mask_x, mask_y)

			# Solo borramos donde la plancha no es transparente
			if mask_pixel.a < 0.1:
				continue

			var px = int(pos.x - visual_w / 2 + x)
			var py = int(pos.y - visual_h / 2 + y)

			if px < 0 or py < 0 or px >= img_w or py >= img_h:
				continue

			var current = imageArrugada.get_pixel(px, py)

			if current.a > 0.01:
				imageArrugada.set_pixel(px, py, Color(1, 1, 1, 0))
				transparent_pixels += 1

	textureArrugada.update(imageArrugada)

func setBrushSize(size):
	brush_size = int(size/20)
	
func get_totalPixels(image):
	total_pixels = 0
	for x in range(image.get_width()):
		for y in range(image.get_height()):

			if image.get_pixel(x, y).a > 0.01:
				total_pixels += 1

func enable_plancha_cursor():

	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	iron_cursor.visible = true
	
	last_mouse_pos = get_global_mouse_position()

func disable_plancha_cursor():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	iron_cursor.visible = false
	
func update_plancha_cursor_pos():
	var mouse_pos = get_global_mouse_position()

	var size = iron_cursor.size
	var center_offset = size / 2

	# ✔ centrar cursor
	iron_cursor.global_position = mouse_pos - center_offset

	# ✔ velocidad correcta (SIN offset)
	var speed = mouse_pos.distance_to(last_mouse_pos)

	# ✔ inclinación
	var tilt = clamp(speed * 0.01, -0.5, 0.5)

	iron_cursor.rotation = lerp(iron_cursor.rotation, tilt, 0.2)

	last_mouse_pos = mouse_pos

func _on_texture_button_pressed() -> void:
	visible = !visible
	reset_values_minigame()
