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

var player: Shape

var nextPlayer: Shape

var opponent: Array[Square]

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
  nextPlayer = Tetromino.random()
  opponent = []
  isPlayerFalling = false
  nextFall = Time.get_ticks_msec() + Config.INITIAL_FALL_RATE
  fallRate = Config.INITIAL_FALL_RATE
  endOfLock = 0
  isMoppingFloor = false
  timeRemainingAfterPaused = 0
  clearQueue()
  state = State.PLAYING
  previousState = State.PLAYING

  spawnPlayer()


func _process(_delta: float) -> void:
  if state == State.GAME_OVER:
    clearQueue()
    # TODO should switch to gameover
    print("Game is over, should quit now")
    return

  for command in commandQueue:
    match command:
      Command.CLOSE:
        clearQueue()
        get_tree().quit()
        return
      Command.RESTART:
        clearQueue()
        get_tree().reload_current_scene()
        return
      Command.PAUSE:
        clearQueue()
        togglePaused()
        return
      Command.ROTATE:
        rotatePlayer()
      Command.MOVE_LEFT:
        movePlayerLeft()
      Command.MOVE_RIGHT:
        movePlayerRight()
      Command.MOVE_DOWN:
        makePlayerFallNow()

  clearQueue()
  applyGravity()
  queue_redraw()


func _draw() -> void:
  const playfieldOrigin = Vector2i(Config.SIDEBAR_WIDTH, 0)
  Painter.drawGuide(
    self,
    Rect2(playfieldOrigin, Vector2(Config.WAR_ZONE_WIDTH, Config.CANVAS_HEIGHT)),
  )

  Painter.drawShape(self, player, playfieldOrigin)
  Painter.drawSquares(self, opponent, playfieldOrigin)

  draw_rect(Rect2(0, 0, Config.SIDEBAR_WIDTH, Config.CANVAS_HEIGHT), Colors.UI_SIDEBAR_BACKGROUND)

  const nextPlayerOrigin := Vector2i(Config.SQUARE_WIDTH, Config.SQUARE_WIDTH)
  Painter.drawGuide(
    self,
    Rect2(nextPlayerOrigin.x, nextPlayerOrigin.y, Config.SQUARE_WIDTH * 4, Config.SQUARE_WIDTH * 2),
  )
  Painter.drawShape(self, nextPlayer, nextPlayerOrigin)

  draw_multiline_string(
    Painter.FONT,
    Vector2(Config.SQUARE_WIDTH / 3.0, Config.SQUARE_WIDTH * 4),
    "Level\n%d" % score.level,
    HORIZONTAL_ALIGNMENT_LEFT,
    -1,
    Config.FONT_SIZE_SMALL,
    -1,
    Colors.UI_WHITE_TEXT,
  )
  draw_multiline_string(
    Painter.FONT,
    Vector2(Config.SQUARE_WIDTH / 3.0, Config.SQUARE_WIDTH * 6),
    "Cleared\n%d" % score.linesCleared,
    HORIZONTAL_ALIGNMENT_LEFT,
    -1,
    Config.FONT_SIZE_SMALL,
    -1,
    Colors.UI_WHITE_TEXT,
  )
  draw_multiline_string(
    Painter.FONT,
    Vector2(Config.SQUARE_WIDTH / 3.0, Config.SQUARE_WIDTH * 8),
    "Total\n%d" % score.total,
    HORIZONTAL_ALIGNMENT_LEFT,
    -1,
    Config.FONT_SIZE_SMALL,
    -1,
    Colors.UI_WHITE_TEXT,
  )


func _input(event: InputEvent) -> void:
  if event.is_action_pressed("Quit", true):
    commandQueue.append(Command.CLOSE)
  if event.is_action_pressed("Restart", true):
    commandQueue.append(Command.RESTART)

  var inTheAction := state == State.PLAYING or state == State.ON_FLOOR

  if inTheAction or state == State.PAUSED:
    if event.is_action_pressed("Pause", true):
      commandQueue.append(Command.PAUSE)

  if inTheAction:
    if event.is_action_pressed("Rotate", true):
      commandQueue.append(Command.ROTATE)
    if event.is_action_pressed("MoveLeft", true):
      commandQueue.append(Command.MOVE_LEFT)
    if event.is_action_pressed("MoveRight", true):
      commandQueue.append(Command.MOVE_RIGHT)
    if event.is_action_pressed("MoveDown", true):
      commandQueue.append(Command.MOVE_DOWN)


func applyGravity() -> void:
  match state:
    State.ON_FLOOR:
      mopTheFloor()
    State.PLAYING:
      makePlayerFall()


func makePlayerFall() -> void:
  var now := Time.get_ticks_msec()
  if now < nextFall or isPlayerFalling:
    return

  isPlayerFalling = true

  var ableToMove := movePlayerDown()

  if ableToMove:
    state = State.PLAYING
    nextFall = now + fallRate
  else:
    state = State.ON_FLOOR
    endOfLock = now + Config.FLOOR_LOCK_RATE
    nextFall = endOfLock

  isPlayerFalling = false


func makePlayerFallNow() -> void:
  if state != State.PLAYING:
    return

  nextFall = 0
  score.total += 1
  makePlayerFall()


func mopTheFloor() -> void:
  var now := Time.get_ticks_msec()
  if now < endOfLock or isMoppingFloor:
    return

  isMoppingFloor = true

  var ableToMove := movePlayerDown()

  if ableToMove:
    state = State.PLAYING
  else:
    eatPlayer()
    var fullRows := findFullRows(opponent)
    var fullRowsCount := fullRows.size()
    if fullRowsCount > 0:
      removeOpponentFullRows(fullRows)
      updateScore(fullRowsCount)

    if spawnPlayer():
      state = State.PLAYING
      nextFall = now + fallRate
    else:
      state = State.GAME_OVER

  isMoppingFloor = false


func spawnPlayer() -> bool:
  var foreshadow := nextPlayer.copy()
  foreshadow.row = 0
  foreshadow.column = floori((Config.PUZZLE_WIDTH - foreshadow.width) / 2.0)
  var overlaps := foreshadow.overlapsSquares(opponent)
  if (overlaps):
    foreshadow.row = -1
    overlaps = foreshadow.overlapsSquares(opponent)
    if (overlaps):
      return false
  player = foreshadow

  nextPlayer = Tetromino.random()

  return true


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

  return ableToMove


func eatPlayer() -> void:
  for square: Square in player.squares:
    var newSquare := square.copy()
    newSquare.cell += player.cell
    opponent.append(newSquare)


func removeOpponentFullRows(fullRows: Array[int]) -> void:
  var squares: Array[Square] = []
  for square in opponent:
    var rowToRemove := false
    for fullRow in fullRows:
      if fullRow == square.row:
        rowToRemove = true
        break
    if rowToRemove:
      continue

    var rowBeforeShifting := square.row
    for fullRow in fullRows:
      if fullRow > rowBeforeShifting:
        square.row += 1

    squares.append(square)

  opponent = squares


func findFullRows(squares: Array[Square]) -> Array[int]:
  var fullRows: Array[int] = []
  var population: Dictionary[int, int] = { }

  for square in squares:
    var value: int = population.get(square.row, 0) + 1
    population.set(square.row, value)

  for row in population.keys():
    if (population.get(row, 0) >= Config.PUZZLE_WIDTH):
      fullRows.append(row)

  return fullRows


func isLegalShapePosition(shape: Shape) -> bool:
  return shape.withinBounds() and not shape.overlapsSquares(opponent)


func clearQueue() -> void:
  commandQueue.clear()
