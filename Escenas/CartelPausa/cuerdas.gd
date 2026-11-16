@tool
extends Control
## Dibuja el clavo y las dos cuerdas a partir de la placa (sigue su giro).

const COLOR_CUERDA := Color8(196, 172, 124)
const COLOR_CLAVO := Color8(205, 205, 212)
const COLOR_CLAVO_SOMBRA := Color8(70, 70, 76)

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var placa := get_node_or_null("../Placa") as Control
	if placa == null:
		return
	var k: float = placa.size.x / 110.0  # 1 píxel del arte original
	var centro_x: float = placa.position.x + placa.size.x / 2.0
	var arriba: float = placa.position.y
	var clavo := Vector2(centro_x, arriba - 14.0 * k)
	var ancho: float = placa.size.x * abs(placa.scale.x)
	var margen: float = min(14.0 * k, ancho / 2.0)
	var grosor: float = max(1.0, 1.5 * k)
	var y_cuerda: float = arriba + 2.0 * k
	draw_line(clavo, Vector2(centro_x - ancho / 2.0 + margen, y_cuerda), COLOR_CUERDA, grosor)
	draw_line(clavo, Vector2(centro_x + ancho / 2.0 - margen, y_cuerda), COLOR_CUERDA, grosor)
	draw_rect(Rect2(clavo - Vector2(1.5, 1.5) * k, Vector2(3, 3) * k), COLOR_CLAVO_SOMBRA)
	draw_rect(Rect2(clavo - Vector2(1.5, 1.5) * k, Vector2(2, 2) * k), COLOR_CLAVO)
