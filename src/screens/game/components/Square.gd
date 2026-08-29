extends Polygon2D

static var SW = Config.SQUARE_WIDTH
static var BW = Config.SQUARE_BORDER_WIDTH
static var IW = SW - (BW * 2)

func _draw():
	#draw_rect(Rect2(0, 0, Config.SQUARE_WIDTH, Config.SQUARE_WIDTH), color)
	# left border
	draw_polygon(
		PackedVector2Array([Vector2(0, 0), Vector2(BW, BW), Vector2(BW, SW - BW), Vector2(0, SW)]),
		PackedColorArray([Colors.SQUARE_BORDER_SIDE])
	)
	# right border
	draw_polygon(
		PackedVector2Array(
			[Vector2(SW, 0), Vector2(SW - BW, BW), Vector2(SW - BW, SW - BW), Vector2(SW, SW)]
		),
		PackedColorArray([Colors.SQUARE_BORDER_SIDE])
	)

	# top border
	draw_polygon(
		PackedVector2Array([Vector2(0, 0), Vector2(BW, BW), Vector2(SW - BW, BW), Vector2(SW, 0)]),
		PackedColorArray([Colors.SQUARE_BORDER_TOP])
	)
	# bottom border
	draw_polygon(
		PackedVector2Array(
			[Vector2(0, 0 + SW), Vector2(BW, SW - BW), Vector2(SW - BW, SW - BW), Vector2(SW, SW)]
		),
		PackedColorArray([Colors.SQUARE_BORDER_BOTTOM])
	)
