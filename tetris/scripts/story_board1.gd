extends Control

func _ready() -> void:
	$back_button.pressed.connect(_on_back_pressed)
	$next_button.pressed.connect(_on_next_pressed)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/story_mode_select.tscn")

func _on_next_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/story_board_2.tscn")
