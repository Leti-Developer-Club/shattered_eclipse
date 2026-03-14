extends Control

var timer: float = 0.0
var display_time: float = 3.0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	timer += delta
	if timer >= display_time or Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
