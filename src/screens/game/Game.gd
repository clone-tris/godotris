extends Node2D


func _ready() -> void:
  # var squares = [
  # 	Square.create(Vector2i(0, 0), Colors.TETROMINO_CYAN),
  # 	Square.create(Vector2i(1, 0), Colors.TETROMINO_CYAN),
  # 	Square.create(Vector2i(2, 0), Colors.TETROMINO_CYAN),
  # 	Square.create(Vector2i(3, 0), Colors.TETROMINO_CYAN),
  # ]

  # for s in squares:
  # 	add_child(s)
  pass

func _draw() -> void:
  Painter.drawGuide(self, Rect2(Vector2(Config.SIDEBAR_WIDTH, 0), Vector2(Config.WAR_ZONE_WIDTH, Config.CANVAS_HEIGHT)))
