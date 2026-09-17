extends Control

@onready var windowsControl = $Windows
@onready var taskBarHbox = $"task bar/AppsHBox"
@onready var animation = $"../AnimationPlayer"
var appsOpened: Dictionary = {}

func _ready() -> void:
	set_button_signals()
	$StartPC/ProgressBar.value = 0
	Signals.closeWindow.connect(close_Window)

func set_button_signals():
	for button in $Windows/Wallpaper/Apps.get_children():
		button.pressed.connect(open_app.bind(button))

func _on_startbutton_pressed() -> void:
	animation.play("PC_Close")
	$"..".visible = false

func open_app(button: TextureButton):
	print("Checkeando Botton pulsado: ", button.name)
	var taskBar_Button = check_app_already_opened(button.name)
	
	if !taskBar_Button:
		print("No existia")
		var new_app = button.app_scene.instantiate()
		windowsControl.add_child(new_app)
		print("Añadido como hijo")
		new_app.visible = false
		print(new_app.visible)
		print(new_app.position)
		
		taskBar_Button = addButtonTaskBar(button)
		appsOpened[taskBar_Button] = new_app
		
		new_app.toggle_minimizeWindow()
	else:
		print("Ya existia")
		appsOpened[taskBar_Button].toggle_minimizeWindow()
	
	focus_on_appOpened(appsOpened[taskBar_Button])

func focus_on_appOpened(appOpened):
	appOpened.z_index = 1
	for app in appsOpened:
		if appOpened != appsOpened[app]:
			appsOpened[app].z_index = 0
	
	
func addButtonTaskBar(button):
	var taskbar_button := TextureButton.new()
	
	taskbar_button.texture_normal = button.texture_normal
	taskbar_button.custom_minimum_size = Vector2(25,25)
	taskbar_button.ignore_texture_size = true
	taskbar_button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	taskbar_button.name = button.name
	
	taskbar_button.pressed.connect(open_app.bind(taskbar_button))
	
	taskBarHbox.add_child(taskbar_button)
	return taskbar_button

func check_app_already_opened(app: String):
	var check = false
	for taskBar_Button in appsOpened:
		if taskBar_Button.name == app:
			return taskBar_Button
			
	return check

func close_Window(window):
	for taskBar_Button in appsOpened:
		if appsOpened[taskBar_Button] == window:
			appsOpened.erase(taskBar_Button)
			window.queue_free()
			taskBar_Button.queue_free()

			break
