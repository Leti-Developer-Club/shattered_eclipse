extends Control

@onready var achievement_container = $MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer
@onready var progress_label = $MarginContainer/VBoxContainer/ProgressLabel

func _ready() -> void:
	$MarginContainer/VBoxContainer/BackButton.pressed.connect(_on_back_pressed)
	display_achievements()

func display_achievements() -> void:
	# Clear existing achievement items
	for child in achievement_container.get_children():
		child.queue_free()
	
	# Check if AchievementManager is available
	if not has_node("/root/AchievementManager"):
		progress_label.text = "Achievement system not loaded"
		return
	
	var achievements = AchievementManager.get_all_achievements()
	var progress = AchievementManager.get_achievement_progress()
	
	progress_label.text = "Progress: %d/%d (%.0f%%)" % [progress.unlocked, progress.total, progress.percentage]
	
	# Display achievements in order
	var achievement_order = ["golden_courts", "northern_libraries", "stone_fortresses", "sankofa_bird"]
	
	for key in achievement_order:
		var achievement = achievements[key]
		create_achievement_item(achievement)

func create_achievement_item(achievement: Dictionary) -> void:
	var item = HBoxContainer.new()
	item.custom_minimum_size = Vector2(0, 80)
	
	# Checkbox
	var checkbox = CheckBox.new()
	checkbox.button_pressed = achievement.unlocked
	checkbox.disabled = true
	checkbox.custom_minimum_size = Vector2(40, 40)
	item.add_child(checkbox)
	
	# Achievement info
	var info_container = VBoxContainer.new()
	info_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	var name_label = Label.new()
	name_label.text = achievement.name
	name_label.add_theme_font_size_override("font_size", 20)
	info_container.add_child(name_label)
	
	var desc_label = Label.new()
	desc_label.text = achievement.description
	desc_label.add_theme_font_size_override("font_size", 14)
	desc_label.modulate = Color(0.8, 0.8, 0.8)
	info_container.add_child(desc_label)
	
	var req_label = Label.new()
	if achievement.has("level_requirement"):
		req_label.text = "Reach Level %d" % achievement.level_requirement
	else:
		req_label.text = "Complete all achievements"
	req_label.add_theme_font_size_override("font_size", 12)
	req_label.modulate = Color(0.6, 0.6, 0.6)
	info_container.add_child(req_label)
	
	item.add_child(info_container)
	
	# Add separator
	var separator = HSeparator.new()
	
	achievement_container.add_child(item)
	achievement_container.add_child(separator)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
