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
    canvas.draw_line(Vector2(rect.position.x, lineY), Vector2(rect.end.x, lineY), Colors.UI_GUIDE)

  for i in columns + 1:
    var lineX := rect.position.x + i * SW
    canvas.draw_line(Vector2(lineX, rect.position.y), Vector2(lineX, rect.end.y), Colors.UI_GUIDE)


static func drawShape(canvas: CanvasItem, shape: Shape, origin: Vector2i) -> void:
  drawSquares(canvas, shape.squares, origin + shape.cell * SW)


static func drawSquares(canvas: CanvasItem, squares: Array[Square], origin: Vector2i) -> void:
  for square in squares:
    drawSquare(canvas, origin + square.cell * SW, square.color)


static func drawSquare(canvas: CanvasItem, position: Vector2, color: Color) -> void:
  canvas.draw_rect(Rect2(position, Vector2(SW, SW)), color)
  # left border
  canvas.draw_polygon(
    PackedVector2Array(
      [
        position,
        position + Vector2(BW, BW),
        position + Vector2(BW, SW - BW),
        position + Vector2(0, SW),
      ]
    ),
    PackedColorArray([Colors.SQUARE_BORDER_SIDE]),
  )
  # right border
  canvas.draw_polygon(
    PackedVector2Array(
      [
        position + Vector2(SW, 0),
        position + Vector2(SW - BW, BW),
        position + Vector2(SW - BW, SW - BW),
        position + Vector2(SW, SW),
      ]
    ),
    PackedColorArray([Colors.SQUARE_BORDER_SIDE]),
  )

  # top border
  canvas.draw_polygon(
    PackedVector2Array(
      [
        position,
        position + Vector2(BW, BW),
        position + Vector2(SW - BW, BW),
        position + Vector2(SW, 0),
      ]
    ),
    PackedColorArray([Colors.SQUARE_BORDER_TOP]),
  )
  # bottom border
  canvas.draw_polygon(
    PackedVector2Array(
      [
        position + Vector2(0, SW),
        position + Vector2(BW, SW - BW),
        position + Vector2(SW - BW, SW - BW),
        position + Vector2(SW, SW),
      ]
    ),
    PackedColorArray([Colors.SQUARE_BORDER_BOTTOM]),
  )
