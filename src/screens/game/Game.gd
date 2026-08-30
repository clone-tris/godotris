extends Node2D

const SW = Config.SQUARE_WIDTH
const playfieldOrigin = Vector2i(Config.SIDEBAR_WIDTH, 0)

var player = Shape.new(
  Vector2.ZERO,
  [
    Square.new(Vector2(0, 0), Colors.TETROMINO_CYAN),
    Square.new(Vector2(0, 1), Colors.TETROMINO_CYAN),
    Square.new(Vector2(1, 1), Colors.TETROMINO_CYAN),
    Square.new(Vector2(1, 2), Colors.TETROMINO_CYAN),
  ],
)

var opponent: Array[Square] = [
  Square.new(Vector2(19, 4), Colors.TETROMINO_CYAN),
  Square.new(Vector2(19, 5), Colors.TETROMINO_GREEN),
  Square.new(Vector2(19, 6), Colors.TETROMINO_PURPLE),
  Square.new(Vector2(19, 7), Colors.TETROMINO_BLUE),
]


func _draw() -> void:
  Painter.drawGuide(
    self,
    Rect2(playfieldOrigin, Vector2(Config.WAR_ZONE_WIDTH, Config.CANVAS_HEIGHT)),
  )

  Painter.drawShape(self, player, playfieldOrigin)
  Painter.drawSquares(self, opponent, playfieldOrigin)
