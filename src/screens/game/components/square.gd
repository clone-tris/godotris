class_name Square

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

var color: Color


func _init(_row: int, _column: int, _color: Color) -> void:
  cell = Vector2i(_column, _row)
  color = _color


func copy() -> Square:
  return Square.new(row, column, color)
