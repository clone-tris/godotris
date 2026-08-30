extends Node2D

func _draw() -> void:
  const playfieldOrigin = Vector2(Config.SIDEBAR_WIDTH, 0)
  const SW = Config.SQUARE_WIDTH

  Painter.drawGuide(self, Rect2(playfieldOrigin, Vector2(Config.WAR_ZONE_WIDTH, Config.CANVAS_HEIGHT)))

  Painter.drawSquareAtPosition(self, playfieldOrigin + Vector2(2 * SW, 2 * SW), Colors.TETROMINO_GREEN)
  Painter.drawSquareAtPosition(self, playfieldOrigin + Vector2(2 * SW, 3 * SW), Colors.TETROMINO_PURPLE)
  Painter.drawSquareAtPosition(self, playfieldOrigin + Vector2(3 * SW, 2 * SW), Colors.TETROMINO_RED)
  Painter.drawSquareAtPosition(self, playfieldOrigin + Vector2(3 * SW, 1 * SW), Colors.TETROMINO_YELLOW)
