class_name Score

const POINTS: Array[int] = [0, 40, 100, 300, 1200]

var level: int
var total: int
var linesCleared: int


func _init() -> void:
  level = 1
  total = 0
  linesCleared = 0
