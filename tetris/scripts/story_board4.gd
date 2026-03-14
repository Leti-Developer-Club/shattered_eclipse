extends Control

func _ready() -> void:
	$back.pressed.connect(_on_back_pressed)  
	$next.pressed.connect(_on_next_pressed)  

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/story_board_3.tscn")

func _on_next_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/story_board_5.tscn")
