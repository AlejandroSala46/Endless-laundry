extends Control
var queueEntregas: Array
var itemSelected: ProductData
var entregaDisp: bool
var placingItem: bool
var buttonEntregas: Button

@onready var animation = $Carretilla/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buttonEntregas = $ButtonEntregas
	Signals.buyItemsCart.connect(startEvent_Entregas)
	entregaDisp = true
	placingItem = false
	animation.play("Entregas_out")

func startEvent_Entregas(arrayItemsEntregas):
	print("Animacion entrada entrega")
	arriveEntregaSleep(3)
	while !entregaDisp:
		await arriveEntregaSleep(3)
	
	animation.play("Entregas_in")
	getQueueEntregas(arrayItemsEntregas)
	
		
func getQueueEntregas(array):
	queueEntregas = array
	entregaDisp = false
	while queueEntregas.size() > 0:
		itemSelected = queueEntregas[0]
		buttonEntregas.icon = itemSelected.icon
		placingItem = false

		while !placingItem:
			await arriveEntregaSleep(1)
		
	animation.play("Entregas_out")
	entregaDisp = true

func buttonEntrega_action():
	if queueEntregas.size() > 0:
		queueEntregas.erase(itemSelected)
		Signals.create_new_station.emit(itemSelected)
		placingItem = true

func arriveEntregaSleep(time):
	await get_tree().create_timer(time).timeout

func onMouseEntered():
	if !placingItem: 
		animation.play("Hover_in")

func onMouseExited():
	if !placingItem: 
		animation.play("Hover_out")
	

	
