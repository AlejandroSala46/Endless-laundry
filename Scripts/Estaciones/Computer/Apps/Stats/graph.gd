class_name Graph
extends Panel

@export var title: String = "GRÁFICO"

# Cada elemento: [label, valor]
@export var values: Array[Array] = [
	["Jan", 20.0],
	["Feb", 35.0],
	["Mar", 30.0],
	["Apr", 55.0],
	["May", 50.0],
	["Jun", 80.0],
	["Jul", 95.0],
	["Aug", 10.0],
	["Sep", 120.0],
	["Oct", 10.0],
	["Nov", 200.0],
	["Dec", 1.0]
]

@export var divisions: int = 10


# Márgenes internos del gráfico
var left_padding := 50.0
var right_padding := 20.0
var top_padding := 40.0
var bottom_padding := 40.0


#func _ready():
	#queue_redraw()

func generate_graph(stat: Array, name: String):
	values = stat
	title = name
	queue_redraw()

func _draw():
	if values.is_empty():
		return

	draw_title()
	draw_grid()
	draw_axes()
	draw_labels()
	draw_graph()


# Obtiene el valor más alto de values
func get_max_value() -> float:
	var highest_value := 0.0

	for data in values:
		if data.size() < 2:
			continue

		var value := float(data[1])

		if value > highest_value:
			highest_value = value

	return highest_value


func draw_title():
	var font = ThemeDB.fallback_font

	var text_size = font.get_string_size(
		title,
		HORIZONTAL_ALIGNMENT_CENTER,
		-1,
		18
	)

	var position = Vector2(
		(size.x - text_size.x) / 2,
		25
	)

	draw_string(
		font,
		position,
		title,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		18,
		Color.BLACK
	)


func draw_axes():
	var origin = Vector2(
		left_padding,
		size.y - bottom_padding
	)

	var top = Vector2(
		left_padding,
		top_padding
	)

	var right = Vector2(
		size.x - right_padding,
		size.y - bottom_padding
	)

	# Eje Y
	draw_line(
		origin,
		top,
		Color.BLACK,
		4.0
	)

	# Eje X
	draw_line(
		origin,
		right,
		Color.BLACK,
		4.0
	)


func draw_grid():
	var graph_height = size.y - top_padding - bottom_padding
	var graph_width = size.x - left_padding - right_padding

	for i in range(divisions + 1):
		var percentage = float(i) / divisions

		var y = size.y - bottom_padding - (graph_height * percentage)

		draw_line(
			Vector2(left_padding, y),
			Vector2(left_padding + graph_width, y),
			Color(0.5, 0.5, 0.5, 0.795),
			2.0
		)


func draw_labels():
	var font = ThemeDB.fallback_font
	var graph_height = size.y - top_padding - bottom_padding
	var graph_width = size.x - left_padding - right_padding
	var max_value = get_max_value()

	if max_value <= 0:
		return


	# =========================
	# ETIQUETAS DEL EJE Y
	# =========================

	for i in range(divisions + 1):
		var percentage = float(i) / float(divisions)
		var value = max_value * percentage

		var y = size.y - bottom_padding - (graph_height * percentage)

		var text = str(int(value))

		# Centramos verticalmente respecto a la línea
		var text_size = font.get_string_size(
			text,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			14
		)

		draw_string(
			font,
			Vector2(
				left_padding - text_size.x - 10,
				y + text_size.y / 2
			),
			text,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			14,
			Color.BLACK
		)


	# =========================
	# ETIQUETAS DEL EJE X
	# =========================

	var spacing = graph_width / float(max(values.size() - 1, 1))

	for i in range(values.size()):
		if values[i].size() < 2:
			continue

		var label = str(values[i][0])

		var x = left_padding + (i * spacing)

		var text_size = font.get_string_size(
			label,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			14
		)

		draw_string(
			font,
			Vector2(
				x - text_size.x / 2,
				size.y - bottom_padding + 25
			),
			label,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			14,
			Color.BLACK
		)


func draw_graph():
	if values.size() < 2:
		return

	var graph_width = size.x - left_padding - right_padding
	var graph_height = size.y - top_padding - bottom_padding
	var max_value = get_max_value()

	if max_value <= 0:
		return

	var points = PackedVector2Array()

	var spacing = graph_width / float(values.size() - 1)

	for i in range(values.size()):
		if values[i].size() < 2:
			continue

		# values[i][0] = Label
		# values[i][1] = Valor
		var value = clamp(float(values[i][1]), 0.0, max_value)

		var percentage = value / max_value

		var x = left_padding + (i * spacing)
		var y = size.y - bottom_padding - (percentage * graph_height)

		points.append(Vector2(x, y))


	# Línea que conecta los puntos
	if points.size() >= 2:
		draw_polyline(
			points,
			Color(0.2, 0.8, 1.0),
			3.0,
			true
		)


	# Dibujar cada punto
	for point in points:
		draw_circle(
			point,
			5.0,
			Color.BLACK
		)
