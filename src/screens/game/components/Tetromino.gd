class_name Tetromino

enum Type {
  I,
  O,
  T,
  J,
  L,
  S,
  Z,
}

const GRIDS: Array[Array] = [
  [[0, 0], [0, 1], [0, 2], [0, 3]], # I
  [[0, 0], [0, 1], [1, 0], [1, 1]], # O
  [[0, 0], [0, 1], [0, 2], [1, 1]], # T
  [[0, 0], [1, 0], [1, 1], [1, 2]], # J
  [[0, 0], [0, 1], [0, 2], [1, 0]], # L
  [[0, 1], [0, 2], [1, 0], [1, 1]], # S
  [[0, 0], [0, 1], [1, 1], [1, 2]], # Z
]

const COLORS: Array[Color] = [
  Colors.TETROMINO_CYAN,
  Colors.TETROMINO_YELLOW,
  Colors.TETROMINO_PURPLE,
  Colors.TETROMINO_BLUE,
  Colors.TETROMINO_ORANGE,
  Colors.TETROMINO_GREEN,
  Colors.TETROMINO_RED,
]


static func makeSquares(type: Type) -> Array[Square]:
  var squares: Array[Square] = []
  var shapeColor := COLORS[type]
  var grid := GRIDS[type]

  for coords in grid:
    squares.append(Square.new(coords[0], coords[1], shapeColor))

  return squares


static var rng := RandomNumberGenerator.new()


static func random() -> Shape:
  var type := rng.randi_range(0, Type.size() - 1) as Type
  var squares := makeSquares(type)
  return Shape.new(0, 0, squares)
