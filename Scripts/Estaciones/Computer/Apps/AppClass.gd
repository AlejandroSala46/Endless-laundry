extends Control
class_name Apps

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scaleImage()


func toggle_minimizeWindow():
	visible = !visible
	

func closeWindow():
	Signals.closeWindow.emit(self)
	
func scaleImage():
	scale = Vector2(size.x/1920, size.y/1080)
	size = Vector2(1920, 1080)
