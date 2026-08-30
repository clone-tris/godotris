class_name Painter

const SW = Config.SQUARE_WIDTH
const BW = Config.SQUARE_BORDER_WIDTH
const IW = SW - (BW * 2)


static func drawGuide(canvas: CanvasItem, rect: Rect2) -> void:
	canvas.draw_rect(rect, Colors.UI_BACKGROUND)

	var rows := int(rect.size.y / SW)
	var columns := int(rect.size.x / SW)

	for i in rows + 1:
		var lineY := rect.position.y + i * SW
		canvas.draw_line(
			Vector2(rect.position.x, lineY),
			Vector2(rect.end.x, lineY),
			Colors.UI_GUIDE,
		)

	for i in columns + 1:
		var lineX := rect.position.x + i * SW
		canvas.draw_line(
			Vector2(lineX, rect.position.y),
			Vector2(lineX, rect.end.y),
			Colors.UI_GUIDE,
		)


static func drawShape(canvas: CanvasItem, shape: Shape, ref: Vector2i) -> void:
	var shapeRef = ref + shape.cell * SW
	for square in shape.squares:
		drawSquareAtPosition(canvas, shapeRef + square.cell * SW, square.color)


static func drawSquareAtPosition(canvas: CanvasItem, position: Vector2, color: Color) -> void:
	canvas.draw_rect(Rect2(position, Vector2(SW, SW)), color)
	var p := position
	# left border
	canvas.draw_polygon(
		PackedVector2Array([p, p + Vector2(BW, BW), p + Vector2(BW, SW - BW), p + Vector2(0, SW)]),
		PackedColorArray([Colors.SQUARE_BORDER_SIDE]),
	)
	# right border
	canvas.draw_polygon(
		PackedVector2Array(
			[
				p + Vector2(SW, 0),
				p + Vector2(SW - BW, BW),
				p + Vector2(SW - BW, SW - BW),
				p + Vector2(SW, SW),
			]
		),
		PackedColorArray([Colors.SQUARE_BORDER_SIDE]),
	)

	# top border
	canvas.draw_polygon(
		PackedVector2Array([p, p + Vector2(BW, BW), p + Vector2(SW - BW, BW), p + Vector2(SW, 0)]),
		PackedColorArray([Colors.SQUARE_BORDER_TOP]),
	)
	# bottom border
	canvas.draw_polygon(
		PackedVector2Array(
			[
				p + Vector2(0, SW),
				p + Vector2(BW, SW - BW),
				p + Vector2(SW - BW, SW - BW),
				p + Vector2(SW, SW),
			]
		),
		PackedColorArray([Colors.SQUARE_BORDER_BOTTOM]),
	)
