extends Node

func setDefaultMouseImages():
	configMouseImage(
		load("res://Sprites/HUD superior, Decoracion y Eventos/Cursor/puño cerrandose 1.png"),
		Input.CURSOR_ARROW
	)
	
	configMouseImage(
		load("res://Sprites/HUD superior, Decoracion y Eventos/Cursor/puño cerrandose 3.png"),
		Input.CURSOR_FORBIDDEN
	)
	
	configMouseImage(
		load("res://Sprites/HUD superior, Decoracion y Eventos/Cursor/puño cerrandose 2.png"),
		Input.CURSOR_CAN_DROP
	)
	
	configMouseImage(
		load("res://Sprites/HUD superior, Decoracion y Eventos/Cursor/puño cerrandose 3.png"),
		Input.CURSOR_DRAG
	)

	configMouseImage(
		load("res://Sprites/HUD superior, Decoracion y Eventos/Cursor/puño con dedo.png"),
		Input.CURSOR_POINTING_HAND
	)

func configMouseImage(texture: Texture2D, cursor_shape: Input.CursorShape):
	var image = texture.get_image()
	image.resize(32, 32)

	var resized_texture = ImageTexture.create_from_image(image)

	Input.set_custom_mouse_cursor(
		resized_texture,
		cursor_shape,
		Vector2(16, 16)
	)
