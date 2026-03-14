extends Control

func _ready() -> void:
	# Play stage clear music for victory
	AudioManager.play_stage_clear_music()
	
	# Connect exit button
	$CenterContainer/VBoxContainer/ExitButton.pressed.connect(_on_exit_pressed)

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mode_select.tscn")
