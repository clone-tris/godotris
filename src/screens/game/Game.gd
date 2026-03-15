extends Node2D

var Square = preload("res://src/screens/game/components/Square.tscn")
var SW = Config.SQUARE_WIDTH

func makeSquare(p: Vector2, color: Color):
	var square: Polygon2D = Square.instantiate()
	square.position = Vector2(p.x * SW, p.y * SW)
	square.color = color
	return square

func _ready() -> void:	
	var squares = [
	 makeSquare(Vector2(0, 0), Colors.TETROMINO_CYAN),
	 makeSquare(Vector2(1, 0), Colors.TETROMINO_CYAN),
	 makeSquare(Vector2(2, 0), Colors.TETROMINO_CYAN),
	 makeSquare(Vector2(3, 0), Colors.TETROMINO_CYAN),
	]
	
	for s in squares:
		add_child(s)
