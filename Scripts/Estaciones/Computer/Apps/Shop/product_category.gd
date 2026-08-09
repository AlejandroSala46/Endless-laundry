extends Control


func set_title(title: String):
	$Label.text = title

func add_product(card: Control):
	$Panel/Grid.add_child(card)
