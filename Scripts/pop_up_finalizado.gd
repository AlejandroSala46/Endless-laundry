extends Control


func show_message(text, sizeX, sizeY):
	var label = get_node("Panel/Label")
	label.text = text
	modulate.a = 0
	visible = true
	
	size = custom_minimum_size
	position = Vector2(sizeX - 20, sizeY - size.y)
	
	# 🔥 ajustar texto
	await get_tree().process_frame
	fit_label_text(label, size)
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.2)
	
	await get_tree().create_timer(2.0).timeout
	
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	await tween.finished
	
	queue_free()
	
func fit_label_text(label: Label, max_size: Vector2):
	var font = label.get_theme_font("font")
	var font_size = label.get_theme_font_size("font_size")

	var text = label.text

	while font_size > 8:
		var text_size = font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)

		if text_size.x <= max_size.x and text_size.y <= max_size.y:
			break

		font_size -= 1

	label.add_theme_font_size_override("font_size", font_size)
