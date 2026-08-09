extends Control

@onready var windowsControl = $Windows
@onready var taskBarHbox = $"task bar/AppsHBox"
var appsOpened: Dictionary

func _ready() -> void:
	set_button_signals()

func set_button_signals():
	for button in $Windows/Wallpaper/Apps.get_children():
		button.pressed.connect(open_app.bind(button))

func _on_startbutton_pressed() -> void:
	$"..".visible = false

func open_app(button: TextureButton):
	print("Checkeando Botton pulsado: ", button.name)
	if check_app_already_opened(button.name):
		print("Ya existia")
		appsOpened[button.name].toggle_minimizeWindow()
	else:
		print("No existia")
		var new_app = button.app_scene.instantiate()
		windowsControl.add_child(new_app)
		print("Añadido como hijo")
		new_app.visible = false
		print(new_app.visible)
		print(new_app.position)
		appsOpened[button.name] = new_app
		
		new_app.toggle_minimizeWindow()
		addButtonTaskBar(button)
		
func check_app_already_opened(app: String) -> bool:
	return appsOpened.has(app)
	
func addButtonTaskBar(button):
	var taskbar_button := TextureButton.new()
	
	taskbar_button.texture_normal = button.texture_normal
	taskbar_button.custom_minimum_size = Vector2(25,25)
	taskbar_button.ignore_texture_size = true
	taskbar_button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	taskbar_button.z_index = 2
	taskbar_button.name = button.name
	
	taskbar_button.pressed.connect(open_app.bind(taskbar_button))
	
	taskBarHbox.add_child(taskbar_button)
