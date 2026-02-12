extends Control

func _ready() -> void:
	$CenterContainer/VBoxContainer/StoryModeButton.pressed.connect(_on_story_mode_pressed)
	$CenterContainer/VBoxContainer/ClassicModeButton.pressed.connect(_on_classic_mode_pressed)
	$CenterContainer/VBoxContainer/BackButton.pressed.connect(_on_back_pressed)
	$CenterContainer/VBoxContainer/StoryModeButton.grab_focus()

func _on_story_mode_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/story_intro.tscn")

func _on_classic_mode_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
