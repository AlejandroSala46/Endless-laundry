extends Node

#World signals
signal world_initializated()
signal building_mode_toggle(parameter: bool)

# DRAG SIGNALS
signal drag_started(order)
signal drag_updated(item, position)
signal drag_ended()

signal create_new_station(station_type)

# signal building_mode()

#Menu signals
signal washingMachine_OpenMenu(stationUI)
signal iron_OpenMenu(stationUI)
signal boardOrders_OpenMenu()
signal pcOpenMenu()

#PC signals
signal closeWindow(windowUI)
#----Shop App
signal addItemToCart(product)
signal buyItemsCart(array)

#Inventory Signals
signal deleteFromInventory(itemInstance)

func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		print("Drag terminado (aunque no haya drop)")
		Signals.drag_ended.emit()
