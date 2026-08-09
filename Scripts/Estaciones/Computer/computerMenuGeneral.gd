extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.pcOpenMenu.connect(openMenu)


func openMenu():
	visible = true

func _on_computer_pressed() -> void:
	$"PC Window".visible = true

func _on_exit_pressed() -> void:
	visible = false
