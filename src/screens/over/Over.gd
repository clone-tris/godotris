extends Control

func _on_retry_button_pressed() -> void:
  get_tree().change_scene_to_file("res://src/screens/game/Game.tscn")

func _on_menu_button_pressed() -> void:
  print("go menu")

func _on_quit_button_pressed() -> void:
  get_tree().quit()
