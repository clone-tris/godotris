class_name Painter

const SW = Config.SQUARE_WIDTH

static func drawGuide(canvas: CanvasItem, rect: Rect2) -> void:
  canvas.draw_rect(rect, Colors.UI_BACKGROUND)

  var rows := int(rect.size.y / SW)
  var columns := int(rect.size.x / SW)

  for i in rows + 1:
    var lineY := rect.position.y + i * SW
    canvas.draw_line(
      Vector2(rect.position.x, lineY), Vector2(rect.end.x, lineY), Colors.UI_GUIDE
    )

  for i in columns + 1:
    var lineX := rect.position.x + i * SW
    canvas.draw_line(
      Vector2(lineX, rect.position.y), Vector2(lineX, rect.end.y), Colors.UI_GUIDE
    )
