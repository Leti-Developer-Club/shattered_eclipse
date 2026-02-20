extends Control

func _ready() -> void:
	$CenterContainer/VBoxContainer/StoryModeButton.pressed.connect(_on_story_mode_pressed)
	$CenterContainer/VBoxContainer/ClassicModeButton.pressed.connect(_on_classic_mode_pressed)
	$CenterContainer/VBoxContainer/BackButton.pressed.connect(_on_back_pressed)
	$CenterContainer/VBoxContainer/StoryModeButton.grab_focus()
	$CenterContainer/VBoxContainer/how_to_play.pressed.connect(_on_how_to_play_pressed)
func _on_story_mode_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/story_mode_select.tscn")

func _on_classic_mode_pressed() -> void:
	# Set classic mode flag (no achievements)
	get_tree().root.set_meta("is_story_mode", false)
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_how_to_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/how_to_play.tscn")
