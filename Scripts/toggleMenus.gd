extends Control


# Called when the node enters the scene tree for the first time.
func toggle_ready() -> void:
	print("Toggle menus preparandose")
	for b in $Estaciones.get_children():
		if b is TextureButton:
			b.pressed.connect(
				func():
					_on_pressed_Estaciones(b.name)
			)
			print(b.name)
			
	$Tablero.pressed.connect(func():
		_on_pressed_Estaciones("Tablero")
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_pressed_Estaciones(button_Pressed) -> void: 
	print("boton pulsado")
	show_Menu_Estaciones(button_Pressed)
	

func show_Menu_Estaciones(name):
	print("Boton pulsado: ", name)
	var menuToShow = get_node("/root/escena_principal/wallpaper/Menus/Estaciones/%s Menu" % name)
	
	if !menuToShow.visible: 
		hide_Menus()
		menuToShow.visible = true
	else:
		menuToShow.visible = false
	print(menuToShow.visible)

func hide_Menus():
	var ContenedorMenus = get_node("/root/escena_principal/wallpaper/Menus/Estaciones")
	for m in ContenedorMenus.get_children():
			m.visible = false
			
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index in [MOUSE_BUTTON_WHEEL_UP, MOUSE_BUTTON_WHEEL_DOWN]:
			return
		hide_Menus()
