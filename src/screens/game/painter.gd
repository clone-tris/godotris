class_name GamePainter


static func drawPlayfield(canvas: CanvasItem, player: Shape, opponent: Array[Square]) -> void:
  const playfieldOrigin = Vector2i(Config.SIDEBAR_WIDTH, 0)
  Painter.drawGuide(
    canvas,
    Rect2(playfieldOrigin, Vector2(Config.WAR_ZONE_WIDTH, Config.CANVAS_HEIGHT)),
  )

  Painter.drawShape(canvas, player, playfieldOrigin)
  Painter.drawSquares(canvas, opponent, playfieldOrigin)



static func drawSidebar(canvas: CanvasItem, nextPlayer: Shape, score: Score) -> void:
  canvas.draw_rect(Rect2(0, 0, Config.SIDEBAR_WIDTH, Config.CANVAS_HEIGHT), Colors.UI_SIDEBAR_BACKGROUND)

  const nextPlayerOrigin := Vector2i(Config.SQUARE_WIDTH, Config.SQUARE_WIDTH)
  Painter.drawGuide(
    canvas,
    Rect2(nextPlayerOrigin.x, nextPlayerOrigin.y, Config.SQUARE_WIDTH * 4, Config.SQUARE_WIDTH * 2),
  )
  Painter.drawShape(canvas, nextPlayer, nextPlayerOrigin)

  canvas.draw_multiline_string(
    Painter.FONT,
    Vector2(Config.SQUARE_WIDTH / 3.0, Config.SQUARE_WIDTH * 4),
    "Level\n%d" % score.level,
    HORIZONTAL_ALIGNMENT_LEFT,
    -1,
    Config.FONT_SIZE_SMALL,
    -1,
    Colors.UI_WHITE_TEXT,
  )
  canvas.draw_multiline_string(
    Painter.FONT,
    Vector2(Config.SQUARE_WIDTH / 3.0, Config.SQUARE_WIDTH * 6),
    "Cleared\n%d" % score.linesCleared,
    HORIZONTAL_ALIGNMENT_LEFT,
    -1,
    Config.FONT_SIZE_SMALL,
    -1,
    Colors.UI_WHITE_TEXT,
  )
  canvas.draw_multiline_string(
    Painter.FONT,
    Vector2(Config.SQUARE_WIDTH / 3.0, Config.SQUARE_WIDTH * 8),
    "Total\n%d" % score.total,
    HORIZONTAL_ALIGNMENT_LEFT,
    -1,
    Config.FONT_SIZE_SMALL,
    -1,
    Colors.UI_WHITE_TEXT,
  )
