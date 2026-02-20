extends Control

func _ready() -> void:
	# Connect the back button
	if has_node("BackButton"):
		$BackButton.pressed.connect(_on_back_pressed)
		$BackButton.grab_focus()
	elif has_node("CenterContainer/VBoxContainer/BackButton"):
		$CenterContainer/VBoxContainer/BackButton.pressed.connect(_on_back_pressed)
		$CenterContainer/VBoxContainer/BackButton.grab_focus()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mode_select.tscn")
