extends Control

var stationUI

@export var fill_time: float = 1  # Segundos para llenar
@onready var alturaMaxlimits = $Detergent/Background.size.y
@onready var button_onOff = get_node("OnOff")
@onready var progress_bar_detergent = get_node("Detergent/Background/Level")
@onready var progress_bar_softener = get_node("Softener/Background/Level")
@onready var button_detergent = get_node("Detergent/Button")
@onready var button_softener = get_node("Softener/Button")
@onready var limit_color_softener = get_node("Softener/Background/Limit")
@onready var limit_color_detergent = get_node("Detergent/Background/Limit")

var button_pressed: bool = false
var button_being_pressed
var fill_progress: float = 0.0
var detergent_disp: bool = true

var link_ButtonsLimit: Dictionary = {}

var ropaSuavizada

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Menu lavadora ready")
	Signals.washingMachine_OpenMenu.connect(openMenu)
	linkButtonsToFunctions(button_detergent)
	linkButtonsToFunctions(button_softener)
	
	link_ButtonsLimit = {
		button_detergent: progress_bar_detergent, 
		button_softener: progress_bar_softener
	}
	
func linkButtonsToFunctions(button):
	button.button_down.connect(_on_button_down.bind(button))
	button.button_up.connect(_on_button_up.bind(button))
	
func openMenu(stationUI_receiver):
	stationUI = stationUI_receiver
	startMenuVariables()
	visible = true

func startMenuVariables():
	progress_bar_detergent.value = stationUI.progress_var_detergent_Station.value
	if progress_bar_detergent.value > 0:
		button_detergent.disabled = true
	else:
		button_detergent.disabled = false
		
	progress_bar_softener.value = stationUI.progress_var_softener_Station.value
	if progress_bar_softener.value > 0:
		button_softener.disabled = true
	else:
		button_softener.disabled = false
	
	var randLimitDetergent = stationUI.randomLimitDet
	update_limit(limit_color_detergent, randLimitDetergent)
	
	var randLimitSoftener = stationUI.randomLimitSua
	update_limit(limit_color_softener, randLimitSoftener)

func toggle_washingMachine_On_Off() -> void:
	
	if detergent_disp:
		stationUI.show_popup("Falta por poner el detergent")
		return
	visible = false
	var checkLavado = false
	var checkSuavizado = false

	# Si el progress bar está dentro del límite
	if checkWash(limit_color_detergent, progress_bar_detergent):
		checkLavado = true
		if checkWash(limit_color_softener, progress_bar_softener):
			checkSuavizado = true
		
	stationUI.proceso_lavado(checkLavado, checkSuavizado)
	
func update_limit(limit, randomLimit):
	print("Actualizando limit")
	limit.position.y = alturaMaxlimits - alturaMaxlimits*(randomLimit/100.0)

	limit.size.y = alturaMaxlimits/10

func _on_button_down(button) -> void:
	if	!button.disabled:
		button_pressed = true
		button_being_pressed = button

func _on_button_up(button) -> void:
	button_pressed = false
	button.disabled = true
	button_being_pressed = null
	fill_progress = 0
	stationUI.updateProgressVarStation(progress_bar_detergent.value, progress_bar_softener.value)
	
	if progress_bar_detergent.value > 0:
		detergent_disp = false
	
func _process(delta):
	if button_pressed and button_being_pressed != null:
		fill_progress += delta / fill_time
		fill_progress = clamp(fill_progress, 0.0, 1.0)
		
		print(fill_time)
		link_ButtonsLimit[button_being_pressed].value = fill_progress * 100  # Si tu barra va de 0-100

func reserdetergent():
	progress_bar_detergent.value = 0
	progress_bar_softener.value = 0
	detergent_disp = true
	fill_progress = 0
	ropaSuavizada = false
	
	stationUI.updateProgressVarStation(progress_bar_detergent.value, progress_bar_softener.value)
	
	for b in link_ButtonsLimit:
		b.disabled = false

func checkWash(limit, progress_bar):
	var limit_position = limit.position.y + limit.size.y
	
	var progress_bar_y = progress_bar.size.y - (progress_bar.value/100.0) * progress_bar.size.y

	# Si el progress bar está dentro del límite
	if progress_bar_y <= limit_position:
		return true
	else:
		return false

func _on_tapa_abierta_pressed() -> void:
	visible = !visible
	reserdetergent()
