class_name Square

var cell: Vector2i

var row: int:
  get:
    return cell.x

var column: int:
  get:
    return cell.y

var color: Color


func _init(_cell: Vector2i, _color: Color) -> void:
  cell = _cell
  color = _color
