extends Button


func _ready() -> void:
  size.x = ceili(size.x / Config.SQUARE_WIDTH) * Config.SQUARE_WIDTH
