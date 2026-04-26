extends TextureButton

var menuOrdenes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Boton de ordenador listo")
	menuOrdenes = get_node("/root/escena_principal/wallpaper/Menus/Orders")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_pressed() -> void:
	print("Boton del ordenador pulsado")
	var ContenedorMenus = get_node("/root/escena_principal/wallpaper/Menus")
	
	if !menuOrdenes.visible: 
		for m in ContenedorMenus.get_children():
			m.visible = false
		menuOrdenes.visible = true
	else:
		menuOrdenes.visible = false
	print(menuOrdenes.visible)
