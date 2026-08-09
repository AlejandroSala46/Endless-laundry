extends Button
@onready var itemIcon: TextureRect = $Box/Panel/IconItem
var itemInventory: ProductData

func changeItemIcon(item):
	itemInventory = item
	itemIcon.texture = itemInventory.icon
	
func onClick():
	print("Click")
	Signals.create_new_station.emit(itemInventory)
	Signals.deleteFromInventory.emit(self)
