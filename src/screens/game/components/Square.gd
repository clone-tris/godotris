class_name Square

const SW = Config.SQUARE_WIDTH
const BW = Config.SQUARE_BORDER_WIDTH
const IW = SW - (BW * 2)

static func create(cell: Vector2i, color: Color) -> Square:
  var square := Square.new()
  square.position = Vector2(cell.x * SW, cell.y * SW)
  square.color = color
  return square
