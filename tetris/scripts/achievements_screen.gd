extends Control

@onready var achievement_container = $MarginContainer/VBoxContainer/VBoxContainer
@onready var progress_label = $MarginContainer/VBoxContainer/ProgressLabel

func _ready() -> void:
	$MarginContainer/VBoxContainer/BackButton.pressed.connect(_on_back_pressed)
	
	# Check if we're coming from a detail page
	if get_tree().root.has_meta("selected_achievement"):
		get_tree().root.remove_meta("selected_achievement")
	
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
	var achievement_order = ["anufo_tribe", "ashanti_kingdom", "ga_tribe", "fante_people", "sankofa_bird"]
	
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
	checkbox.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	item.add_child(checkbox)
	
	var press_start_font = load("res://assets/PressStart2P-Regular.ttf")
	
	# Make clickable if unlocked
	if achievement.unlocked:
		var button = Button.new()
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		
		var info_container = VBoxContainer.new()
		info_container.alignment = BoxContainer.ALIGNMENT_CENTER
		
		var name_label = Label.new()
		name_label.text = achievement.name
		name_label.add_theme_font_size_override("font_size", 16)
		name_label.add_theme_font_override("font", press_start_font)
		info_container.add_child(name_label)
		
		var desc_label = Label.new()
		desc_label.text = achievement.description + " (Click to read)"
		desc_label.add_theme_font_size_override("font_size", 8)
		desc_label.add_theme_font_override("font", press_start_font)
		desc_label.modulate = Color(0.8, 0.8, 0.8)
		info_container.add_child(desc_label)
		
		button.add_child(info_container)
		button.pressed.connect(_on_achievement_clicked.bind(achievement))
		item.add_child(button)
	else:
		# Locked achievement
		var info_container = VBoxContainer.new()
		info_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		info_container.alignment = BoxContainer.ALIGNMENT_CENTER
		
		var name_label = Label.new()
		name_label.text = "???"
		name_label.add_theme_font_size_override("font_size", 16)
		name_label.add_theme_font_override("font", press_start_font)
		info_container.add_child(name_label)
		
		var desc_label = Label.new()
		desc_label.text = achievement.description
		desc_label.add_theme_font_size_override("font_size", 8)
		desc_label.add_theme_font_override("font", press_start_font)
		desc_label.modulate = Color(0.8, 0.8, 0.8)
		info_container.add_child(desc_label)
		
		var req_label = Label.new()
		if achievement.has("level_requirement"):
			req_label.text = "Reach Level %d" % achievement.level_requirement
		else:
			req_label.text = "Complete all achievements"
		req_label.add_theme_font_size_override("font_size", 8)
		req_label.add_theme_font_override("font", press_start_font)
		req_label.modulate = Color(0.6, 0.6, 0.6)
		info_container.add_child(req_label)
		
		item.add_child(info_container)
	
	# Add separator
	var separator = HSeparator.new()
	
	achievement_container.add_child(item)
	achievement_container.add_child(separator)

func _on_achievement_clicked(achievement: Dictionary) -> void:
	# Store achievement data and switch to detail scene
	get_tree().root.set_meta("selected_achievement", achievement)
	get_tree().change_scene_to_file("res://scenes/achievement_detail.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
