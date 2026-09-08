extends Node2D


func _on_start_button_pressed() -> void:
  get_tree().change_scene_to_file("res://src/screens/game/Game.tscn")


func _on_quit_button_pressed() -> void:
  get_tree().quit()

func _input(event: InputEvent) -> void:
  if event.is_action_pressed("Quit", true):
    get_tree().quit()
  if event.is_action_pressed("Start", true):
    get_tree().change_scene_to_file("res://src/screens/game/Game.tscn")
