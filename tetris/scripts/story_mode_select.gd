extends Control

func _ready() -> void:
	$CenterContainer/VBoxContainer/NewQuestButton.pressed.connect(_on_new_quest_pressed)
	$CenterContainer/VBoxContainer/LoadQuestButton.pressed.connect(_on_load_quest_pressed)
	$CenterContainer/VBoxContainer/BackButton.pressed.connect(_on_back_pressed)
	
	# Check if there's saved progress
	if AchievementManager.has_story_progress():
		var progress = AchievementManager.load_story_progress()
		$CenterContainer/VBoxContainer/LoadQuestButton.text = "Load Quest (Level %d)" % progress.level
		$CenterContainer/VBoxContainer/LoadQuestButton.disabled = false
		$CenterContainer/VBoxContainer/LoadQuestButton.grab_focus()
	else:
		$CenterContainer/VBoxContainer/LoadQuestButton.text = "Load Quest (No Save)"
		$CenterContainer/VBoxContainer/LoadQuestButton.disabled = true
		$CenterContainer/VBoxContainer/NewQuestButton.grab_focus()

func _on_new_quest_pressed() -> void:
	# Clear any existing progress and start fresh
	AchievementManager.clear_story_progress()
	get_tree().change_scene_to_file("res://scenes/story_board_1.tscn")

func _on_load_quest_pressed() -> void:
	# Load saved progress and pass it to the game
	var progress = AchievementManager.load_story_progress()
	get_tree().root.set_meta("is_story_mode", true)
	get_tree().root.set_meta("story_progress_data", progress)
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mode_select.tscn")
