extends Control

var achievement_data: Dictionary = {}

func _ready() -> void:
	$MarginContainer/VBoxContainer/BackButton.pressed.connect(_on_back_pressed)
	
	# Get achievement data from meta
	if get_tree().root.has_meta("selected_achievement"):
		achievement_data = get_tree().root.get_meta("selected_achievement")
	
	display_achievement()

func set_achievement(achievement: Dictionary) -> void:
	achievement_data = achievement
	if is_node_ready():
		display_achievement()

func display_achievement() -> void:
	if achievement_data.is_empty():
		return
	
	# Set title
	$MarginContainer/VBoxContainer/Title.text = achievement_data.name
	
	# Clear existing pages
	var page_container = $MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer
	for child in page_container.get_children():
		child.queue_free()
	
	# Add pages
	if achievement_data.has("pages"):
		for i in range(achievement_data.pages.size()):
			var page_num = i + 1
			
			# Page header
			var header = Label.new()
			header.text = "Page %d" % page_num
			header.add_theme_font_size_override("font_size", 24)
			header.add_theme_color_override("font_color", Color(1, 0.8, 0, 1))  # Gold
			page_container.add_child(header)
			
			# Page content
			var content = Label.new()
			content.text = achievement_data.pages[i]
			content.add_theme_font_size_override("font_size", 16)
			content.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			page_container.add_child(content)
			
			# Separator (except after last page)
			if i < achievement_data.pages.size() - 1:
				var separator = HSeparator.new()
				page_container.add_child(separator)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/achievements_screen.tscn")
