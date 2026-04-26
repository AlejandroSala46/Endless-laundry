extends Control

func show_message(text):
	var label = get_node("Panel/Label")
	label.text = text
	modulate.a = 0
	visible = true

	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.2)
	
	await get_tree().create_timer(2.0).timeout
	
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	await tween.finished
	
	queue_free()
