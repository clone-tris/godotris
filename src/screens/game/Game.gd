extends Node2D

const SW = Config.SQUARE_WIDTH
const playfieldOrigin = Vector2i(Config.SIDEBAR_WIDTH, 0)

var player = Shape.new(
  0,
  0,
  [
    Square.new(0, 0, Colors.TETROMINO_RED),
    Square.new(0, 1, Colors.TETROMINO_RED),
    Square.new(1, 1, Colors.TETROMINO_RED),
    Square.new(1, 2, Colors.TETROMINO_RED),
  ],
)

var opponent: Array[Square] = [
  Square.new(19, 4, Colors.TETROMINO_CYAN),
  Square.new(19, 5, Colors.TETROMINO_GREEN),
  Square.new(19, 6, Colors.TETROMINO_PURPLE),
  Square.new(19, 7, Colors.TETROMINO_BLUE),
]


func _draw() -> void:
  Painter.drawGuide(
    self,
    Rect2(playfieldOrigin, Vector2(Config.WAR_ZONE_WIDTH, Config.CANVAS_HEIGHT)),
  )

  Painter.drawShape(self, player, playfieldOrigin)
  Painter.drawSquares(self, opponent, playfieldOrigin)


func _input(event: InputEvent) -> void:
  if event.is_action_pressed("Rotate", true):
    movePlayer(Vector2i(0, -1))
  if event.is_action_pressed("MoveLeft", true):
    movePlayerLeft()
  if event.is_action_pressed("MoveRight", true):
    movePlayerRight()
  if event.is_action_pressed("MoveDown", true):
    movePlayerDown()


func movePlayerLeft() -> void:
  movePlayer(Vector2i(-1, 0))


func movePlayerRight() -> void:
  movePlayer(Vector2i(1, 0))


func movePlayerDown() -> void:
  movePlayer(Vector2i(0, 1))


func movePlayer(direction: Vector2i) -> bool:
  var foreshadow := player.copy()
  foreshadow.translate(direction)

  var ableToMove := isLegalShapePosition(foreshadow)
  if (ableToMove):
    player = foreshadow
    queue_redraw()

  return ableToMove


func isLegalShapePosition(shape: Shape) -> bool:
  return shape.withinBounds() and not shape.overlapsSquares(opponent)
