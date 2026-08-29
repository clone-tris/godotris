extends Node2D


func _ready() -> void:
	var squares = [
		Square.create(Vector2i(0, 0), Colors.TETROMINO_CYAN),
		Square.create(Vector2i(1, 0), Colors.TETROMINO_CYAN),
		Square.create(Vector2i(2, 0), Colors.TETROMINO_CYAN),
		Square.create(Vector2i(3, 0), Colors.TETROMINO_CYAN),
	]

	for s in squares:
		add_child(s)
