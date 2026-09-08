extends Node2D

static var GRAPHIC: Array[Square] = [
  Square.new(1, 2, Tetromino.COLORS[0]),
  Square.new(2, 2, Tetromino.COLORS[0]),
  Square.new(3, 2, Tetromino.COLORS[0]),
  Square.new(3, 3, Tetromino.COLORS[0]),
  Square.new(3, 5, Tetromino.COLORS[1]),
  Square.new(3, 6, Tetromino.COLORS[1]),
  Square.new(3, 7, Tetromino.COLORS[1]),
  Square.new(2, 7, Tetromino.COLORS[1]),
  Square.new(1, 7, Tetromino.COLORS[1]),
  Square.new(1, 6, Tetromino.COLORS[1]),
  Square.new(1, 5, Tetromino.COLORS[1]),
  Square.new(2, 5, Tetromino.COLORS[1]),
  Square.new(2, 9, Tetromino.COLORS[2]),
  Square.new(1, 10, Tetromino.COLORS[2]),
  Square.new(3, 10, Tetromino.COLORS[2]),
  Square.new(3, 11, Tetromino.COLORS[2]),
  Square.new(2, 11, Tetromino.COLORS[2]),
  Square.new(5, 5, Tetromino.COLORS[3]),
  Square.new(6, 5, Tetromino.COLORS[3]),
  Square.new(6, 4, Tetromino.COLORS[3]),
  Square.new(7, 5, Tetromino.COLORS[3]),
  Square.new(8, 4, Tetromino.COLORS[3]),
  Square.new(7, 3, Tetromino.COLORS[3]),
  Square.new(5, 7, Tetromino.COLORS[4]),
  Square.new(7, 7, Tetromino.COLORS[4]),
  Square.new(8, 7, Tetromino.COLORS[4]),
  Square.new(8, 9, Tetromino.COLORS[5]),
  Square.new(7, 9, Tetromino.COLORS[5]),
  Square.new(6, 9, Tetromino.COLORS[5]),
  Square.new(6, 10, Tetromino.COLORS[5]),
  Square.new(6, 11, Tetromino.COLORS[5]),
  Square.new(7, 11, Tetromino.COLORS[5]),
  Square.new(8, 11, Tetromino.COLORS[5]),
  Square.new(10, 8, Tetromino.COLORS[6]),
  Square.new(11, 7, Tetromino.COLORS[6]),
  Square.new(12, 8, Tetromino.COLORS[6]),
  Square.new(11, 9, Tetromino.COLORS[6]),
  Square.new(12, 9, Tetromino.COLORS[6]),
  Square.new(13, 9, Tetromino.COLORS[6]),
  Square.new(14, 8, Tetromino.COLORS[6]),
  Square.new(14, 11, Tetromino.COLORS[0]),
  Square.new(14, 12, Tetromino.COLORS[0]),
  Square.new(14, 13, Tetromino.COLORS[0]),
]


func _draw() -> void:
  Painter.drawGuide(self, Rect2(0, 0, Config.CANVAS_WIDTH, Config.CANVAS_HEIGHT))
  Painter.drawSquares(self, GRAPHIC, Vector2i.ZERO)


func _on_start_button_pressed() -> void:
  get_tree().change_scene_to_file("res://src/screens/game/Game.tscn")


func _on_quit_button_pressed() -> void:
  get_tree().quit()


func _input(event: InputEvent) -> void:
  if event.is_action_pressed("Quit", true):
    get_tree().quit()
  if event.is_action_pressed("Start", true):
    get_tree().change_scene_to_file("res://src/screens/game/Game.tscn")
