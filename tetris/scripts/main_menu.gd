extends Control

func _ready() -> void:
	$CenterContainer/VBoxContainer/StartButton.pressed.connect(_on_start_pressed)
	$CenterContainer/VBoxContainer/AchievementsButton.pressed.connect(_on_achievements_pressed)
	$CenterContainer/VBoxContainer/ExitButton.pressed.connect(_on_exit_pressed)
	$CenterContainer/VBoxContainer/StartButton.grab_focus()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mode_select.tscn")

func _on_achievements_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/achievements_screen.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
