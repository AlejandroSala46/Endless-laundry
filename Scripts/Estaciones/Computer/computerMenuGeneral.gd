extends Control
@onready var animation = $"PC Window/AnimationPlayer"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.pcOpenMenu.connect(openMenu)


func openMenu():
	visible = true
	animation.play("Open_Table")

func _on_computer_pressed() -> void:
	$"PC Window".visible = true
	animation.play("PC_Open")
	await animation.animation_finished
	animation.play("PC_START")

func _on_exit_pressed() -> void:
	animation.play("Close_Table")
	visible = false
