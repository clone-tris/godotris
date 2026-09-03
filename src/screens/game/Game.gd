extends Node2D

enum Command {
  MOVE_LEFT,
  MOVE_RIGHT,
  MOVE_DOWN,
  ROTATE,
  PAUSE,
  RESTART,
  CLOSE,
}

enum State {
  PAUSED,
  PLAYING,
  ON_FLOOR,
  GAME_OVER,
}

var player := Shape.new(
  0,
  0,
  [
    Square.new(0, 0, Colors.TETROMINO_RED),
    Square.new(0, 1, Colors.TETROMINO_RED),
    Square.new(1, 1, Colors.TETROMINO_RED),
    Square.new(1, 2, Colors.TETROMINO_RED),
  ],
)

var nextPlayer: Shape

var opponent: Array[Square] = [
  Square.new(19, 4, Colors.TETROMINO_CYAN),
  Square.new(19, 5, Colors.TETROMINO_GREEN),
  Square.new(19, 6, Colors.TETROMINO_PURPLE),
  Square.new(19, 7, Colors.TETROMINO_BLUE),
]

var score: Score

var fallRate: int
var nextFall: int
var endOfLock: int
var isPlayerFalling: bool
var isMoppingFloor: bool
var timeRemainingAfterPaused: int
var commandQueue: Array[Command]
var state: State
var previousState: State


func _init() -> void:
  score = Score.new()
  nextPlayer = Shape.new(
    0,
    0,
    [
      Square.new(0, 0, Colors.TETROMINO_RED),
      Square.new(0, 1, Colors.TETROMINO_RED),
      Square.new(1, 1, Colors.TETROMINO_RED),
      Square.new(1, 2, Colors.TETROMINO_RED),
    ],
  )
  opponent = []
  isPlayerFalling = false
  nextFall = Time.get_ticks_msec() + Config.INITIAL_FALL_RATE
  fallRate = Config.INITIAL_FALL_RATE
  endOfLock = 0
  isMoppingFloor = false
  timeRemainingAfterPaused = 0
  commandQueue = []
  state = State.PLAYING
  previousState = State.PLAYING


func _draw() -> void:
  const playfieldOrigin = Vector2i(Config.SIDEBAR_WIDTH, 0)
  Painter.drawGuide(
    self,
    Rect2(playfieldOrigin, Vector2(Config.WAR_ZONE_WIDTH, Config.CANVAS_HEIGHT)),
  )

  Painter.drawShape(self, player, playfieldOrigin)
  Painter.drawSquares(self, opponent, playfieldOrigin)


func _input(event: InputEvent) -> void:
  if event.is_action_pressed("Rotate", true):
    rotatePlayer()
  if event.is_action_pressed("MoveLeft", true):
    movePlayerLeft()
  if event.is_action_pressed("MoveRight", true):
    movePlayerRight()
  if event.is_action_pressed("MoveDown", true):
    movePlayerDown()


func spawnPlayer() -> void:
  pass


func updateScore(linesRemoved: int) -> void:
  var currentLevel := score.level
  assert(linesRemoved >= 0 and linesRemoved <= 4)
  var basePoints := Score.POINTS[linesRemoved]
  var linesCleared := score.linesCleared + linesRemoved
  var level := floori(linesCleared / float(Config.LINES_PER_LEVEL)) + 1
  var points := basePoints * currentLevel
  var total := score.total + points

  if level != currentLevel:
    fallRate -= floori(fallRate / float(Config.FALL_RATE_REDUCTION_FACTOR))

  score.level = level
  score.linesCleared = linesCleared
  score.total = total


func togglePaused() -> void:
  if state == State.PAUSED:
    play()
  elif state == State.PLAYING or state == State.ON_FLOOR:
    pause()


func pause() -> void:
  var now := Time.get_ticks_msec()
  if state == State.PLAYING:
    var remaining := nextFall - now if nextFall > now else 0
    timeRemainingAfterPaused = remaining
  elif state == State.ON_FLOOR:
    var remaining := endOfLock - now if endOfLock > now else 0
    timeRemainingAfterPaused = remaining

  previousState = state
  state = State.PAUSED


func play() -> void:
  var now := Time.get_ticks_msec()
  if previousState == State.PLAYING:
    nextFall = now + timeRemainingAfterPaused
  elif previousState == State.ON_FLOOR:
    endOfLock = now + timeRemainingAfterPaused

  state = previousState


func rotatePlayer() -> void:
  var foreshadow := player.copy()
  foreshadow.rotate()

  var ableToMove := isLegalShapePosition(foreshadow)
  if (ableToMove):
    player = foreshadow
    queue_redraw()


func movePlayerLeft() -> void:
  movePlayer(Vector2i(-1, 0))


func movePlayerRight() -> void:
  movePlayer(Vector2i(1, 0))


func movePlayerDown() -> bool:
  return movePlayer(Vector2i(0, 1))


func movePlayer(direction: Vector2i) -> bool:
  var foreshadow := player.copy()
  foreshadow.translate(direction)

  var ableToMove := isLegalShapePosition(foreshadow)
  if (ableToMove):
    player = foreshadow
    queue_redraw()

  return ableToMove


func eatPlayer() -> void:
  for square: Square in player.squares:
    var newSquare := square.copy()
    newSquare.cell += player.cell
    opponent.append(newSquare)


func isLegalShapePosition(shape: Shape) -> bool:
  return shape.withinBounds() and not shape.overlapsSquares(opponent)
