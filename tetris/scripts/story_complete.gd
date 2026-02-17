extends Control

var timer: float = 0.0
var wait_time: float = 5.0

func _ready() -> void:
	# Play title music for victory
	AudioManager.play_title_music()

func _process(delta: float) -> void:
	timer += delta
	if timer >= wait_time:
		get_tree().change_scene_to_file("res://scenes/mode_select.tscn")
