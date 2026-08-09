extends Station

@onready var animation_player = $AnimationPlayer

func _ready():
	set_signals()

func setupTiles():
	widthTiles = 6
	depthTiles = 4
	

func pcButtonPressed() -> void:
	Signals.pcOpenMenu.emit()
	print("Click")
