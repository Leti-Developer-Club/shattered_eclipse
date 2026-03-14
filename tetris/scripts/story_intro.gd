extends Control

func _ready() -> void:
	$MarginContainer/VBoxContainer/ButtonContainer/StartButton.pressed.connect(_on_start_pressed)
	$MarginContainer/VBoxContainer/ButtonContainer/BackButton.pressed.connect(_on_back_pressed)
	$MarginContainer/VBoxContainer/ButtonContainer/StartButton.grab_focus()
	
	# Display current progress
	update_progress_display()

func update_progress_display() -> void:
	var progress = AchievementManager.get_achievement_progress()
	var progress_text = $MarginContainer/VBoxContainer/ProgressPanel/ProgressLabel
	
	if progress.unlocked == progress.total:
		progress_text.text = "✓ All Sun-Scrolls Restored! You have mastered the chronicles."
		progress_text.modulate = Color(1, 0.8, 0, 1)  # Gold
	else:
		progress_text.text = "Progress: %d/%d Sun-Scrolls Restored" % [progress.unlocked, progress.total]
		progress_text.modulate = Color(0.8, 0.8, 0.8, 1)  # Grey

func _on_start_pressed() -> void:
	# Set story mode flag before starting game
	get_tree().root.set_meta("is_story_mode", true)
	
	# Check if loading saved progress
	if get_tree().root.has_meta("load_story_progress"):
		get_tree().root.set_meta("load_story_progress", false)
		get_tree().root.set_meta("story_progress_data", AchievementManager.load_story_progress())
	
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mode_select.tscn")
