class_name Shape

var cell: Vector2i

var row: int:
  get:
    return cell.y
  set(value):
    cell.y = value

var column: int:
  get:
    return cell.x
  set(value):
    cell.x = value

var width: int = 0
var height: int = 0

var squares: Array[Square] = []


func _init(_row: int, _column: int, _squares: Array[Square]) -> void:
  cell = Vector2i(_column, _row)
  squares = _squares
  computeSize()


func computeSize() -> void:
  var size := squares.size()
  if (size == 0):
    return

  var minRow := Config.PUZZLE_HEIGHT
  var maxRow := 0
  var minColumn := Config.PUZZLE_WIDTH
  var maxColumn := 0

  for square in squares:
    maxRow = maxi(square.row, maxRow)
    minRow = mini(square.row, minRow)
    maxColumn = maxi(square.column, maxColumn)
    minColumn = mini(square.column, minColumn)

  height = maxRow - minRow + 1
  width = maxColumn - minColumn + 1


func copy() -> Shape:
  var newSquares: Array[Square] = []
  for square in squares:
    newSquares.append(square.copy())

  return Shape.new(row, column, newSquares)


func translate(direction: Vector2i):
  cell += direction


func rotate() -> void:
  var newSquares: Array[Square] = []

  for square in squares:
    newSquares.append(Square.new(square.column, height - square.row - 1, square.color))

  squares = newSquares
  computeSize()


func overlapsSquares(otherSquares: Array[Square]) -> bool:
  for square in squares:
    var absolute := square.cell + cell
    for otherSquare in otherSquares:
      if absolute == otherSquare.cell:
        return true

  return false


func withinBounds() -> bool:
  return (
    cell.x >= 0 and (cell.x + width) <= Config.PUZZLE_WIDTH
    and (cell.y + height) <= Config.PUZZLE_HEIGHT
  )
