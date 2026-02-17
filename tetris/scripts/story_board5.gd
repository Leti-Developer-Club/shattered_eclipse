extends Control

func _ready() -> void:
	$back.pressed.connect(_on_back_pressed) 
	$begin_quest.pressed.connect(_on_begin_quest_pressed)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/story_board_4.tscn")

func _on_begin_quest_pressed() -> void:
	# Set story mode flag and start the game
	get_tree().root.set_meta("is_story_mode", true)
	get_tree().change_scene_to_file("res://scenes/main.tscn")
