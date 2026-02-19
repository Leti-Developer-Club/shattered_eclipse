extends Control

var left_vbox: VBoxContainer
var right_vbox: VBoxContainer
var orbitron_font: FontFile

func _ready() -> void:
	# Load the Orbitron font
	orbitron_font = load("res://assets/Orbitron/static/Orbitron-SemiBold.ttf")
	
	# Create left side title
	var left_title = Label.new()
	left_title.text = "JOURNAL"
	left_title.add_theme_font_override("font", orbitron_font)
	left_title.add_theme_color_override("font_color", Color(0, 0, 0, 1))
	left_title.add_theme_font_size_override("font_size", 16)
	left_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	left_title.position = Vector2(90, 60)
	left_title.custom_minimum_size = Vector2(180, 30)
	$book.add_child(left_title)
	
	# Create left side container for achievement names
	left_vbox = VBoxContainer.new()
	left_vbox.name = "LeftVBoxContainer"
	left_vbox.add_theme_constant_override("separation", 15)
	$book.add_child(left_vbox)
	
	# Position relative to the book sprite's scale
	# Left page area
	left_vbox.position = Vector2(90, 110)
	left_vbox.custom_minimum_size = Vector2(180, 300)
	
	# Create right side title
	var right_title = Label.new()
	right_title.text = "COMPLETION"
	right_title.add_theme_font_override("font", orbitron_font)
	right_title.add_theme_color_override("font_color", Color(0, 0, 0, 1))
	right_title.add_theme_font_size_override("font_size", 16)
	right_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	right_title.position = Vector2(320, 60)
	right_title.custom_minimum_size = Vector2(100, 30)
	$book.add_child(right_title)
	
	# Create right side container for progress checkboxes
	right_vbox = VBoxContainer.new()
	right_vbox.name = "RightVBoxContainer"
	right_vbox.add_theme_constant_override("separation", 15)
	$book.add_child(right_vbox)
	
	# Right page area
	right_vbox.position = Vector2(320, 110)
	right_vbox.custom_minimum_size = Vector2(100, 300)
	
	populate_achievements()
	
	# Create back button at the bottom (as child of root, not book sprite)
	var back_button = Button.new()
	back_button.text = "BACK"
	back_button.add_theme_font_override("font", orbitron_font)
	back_button.add_theme_font_size_override("font_size", 18)
	back_button.position = Vector2(410, 560)
	back_button.custom_minimum_size = Vector2(100, 40)
	back_button.pressed.connect(_on_back_pressed)
	add_child(back_button)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func populate_achievements() -> void:
	# Clear existing children
	for child in left_vbox.get_children():
		child.queue_free()
	for child in right_vbox.get_children():
		child.queue_free()
	
	# Get achievements from manager
	var achievements = AchievementManager.get_all_achievements()
	
	# Define the order we want to display achievements
	var achievement_order = [
		"anufo_tribe",
		"ashanti_kingdom", 
		"ga_tribe",
		"fante_people",
		"sankofa_bird"
	]
	
	# Create entry for each achievement
	for key in achievement_order:
		if achievements.has(key):
			var achievement = achievements[key]
			create_achievement_entry(achievement)

func create_achievement_entry(achievement: Dictionary) -> void:
	# Create button for achievement name (left side) - clickable when unlocked
	var button = Button.new()
	button.text = achievement.name
	button.add_theme_font_override("font", orbitron_font)
	button.add_theme_color_override("font_color", Color(0, 0, 0, 1))
	button.add_theme_font_size_override("font_size", 12)
	button.autowrap_mode = TextServer.AUTOWRAP_WORD
	button.custom_minimum_size = Vector2(180, 0)
	button.flat = true  # Make it look like text
	button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	
	# Disable button if achievement is locked
	if not achievement.unlocked:
		button.disabled = true
		button.add_theme_color_override("font_disabled_color", Color(0.5, 0.5, 0.5, 1))
	else:
		# Connect to open detail scene when clicked
		button.pressed.connect(_on_achievement_clicked.bind(achievement))
	
	# Create container to center the checkbox
	var checkbox_container = CenterContainer.new()
	checkbox_container.custom_minimum_size = Vector2(100, 30)
	
	# Create checkbox (right side)
	var checkbox = CheckBox.new()
	checkbox.disabled = true  # Make it read-only
	checkbox.button_pressed = achievement.unlocked
	
	# Add checkbox to center container
	checkbox_container.add_child(checkbox)
	
	# Add to containers
	left_vbox.add_child(button)
	right_vbox.add_child(checkbox_container)

func _on_achievement_clicked(achievement: Dictionary) -> void:
	# Determine which detail scene to load based on achievement
	var scene_path = ""
	
	if achievement.name == "Anufo Tribe":
		scene_path = "res://scenes/achievement_details/anufo_detail.tscn"
	elif achievement.name == "Ashanti Kingdom":
		scene_path = "res://scenes/achievement_details/ashanti_detail.tscn"
	elif achievement.name == "The Ga Tribe":
		scene_path = "res://scenes/achievement_details/ga_detail.tscn"
	elif achievement.name == "The Fantes - Coastal Region":
		scene_path = "res://scenes/achievement_details/fante_detail.tscn"
	elif achievement.name == "The Sankofa Bird":
		scene_path = "res://scenes/achievement_details/sankofa_detail.tscn"
	
	if scene_path != "" and ResourceLoader.exists(scene_path):
		get_tree().change_scene_to_file(scene_path)

func _process(_delta: float) -> void:
	# Update achievement status in real-time
	update_achievement_status()

func update_achievement_status() -> void:
	var achievements = AchievementManager.get_all_achievements()
	var achievement_order = [
		"anufo_tribe",
		"ashanti_kingdom",
		"ga_tribe", 
		"fante_people",
		"sankofa_bird"
	]
	
	var index = 0
	for key in achievement_order:
		if achievements.has(key) and index < right_vbox.get_child_count():
			var achievement = achievements[key]
			var checkbox_container = right_vbox.get_child(index)
			if checkbox_container is CenterContainer and checkbox_container.get_child_count() > 0:
				var checkbox = checkbox_container.get_child(0)
				if checkbox is CheckBox:
					checkbox.button_pressed = achievement.unlocked
			index += 1
