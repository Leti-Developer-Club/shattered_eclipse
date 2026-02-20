extends Control

# Export variables for settings panels
@export var menu: VBoxContainer
@export var main_settings: VBoxContainer
@export var video_settings: VBoxContainer
@export var audio_settings: VBoxContainer
@export var controls_settings: VBoxContainer
@export var language_settings: VBoxContainer

# Export variables for buttons
@export var back_button: Button
@export var settings_button: Button
@export var video_button: Button
@export var audio_button: Button
@export var controls_button: Button
@export var language_button: Button

# Navigation stack for settings panels
var nav_stack: Array[Control] = []
var current_panel: Control

func _ready() -> void:
	# Connect existing main menu buttons
	$CenterContainer/VBoxContainer/StartButton.pressed.connect(_on_start_pressed)
	$CenterContainer/VBoxContainer/AchievementsButton.pressed.connect(_on_achievements_pressed)
	$CenterContainer/VBoxContainer/ExitButton.pressed.connect(_on_exit_pressed)
	$CenterContainer/VBoxContainer/StartButton.grab_focus()
	
	# Initialize settings navigation if settings exist
	if menu:
		current_panel = menu
		_show_panel(menu)
		_update_back_button()
		
		# Connect settings navigation buttons
		if back_button:
			back_button.pressed.connect(_on_back_pressed)
		if settings_button:
			settings_button.pressed.connect(_navigate_to.bind(main_settings))
		if video_button:
			video_button.pressed.connect(_navigate_to.bind(video_settings))
		if audio_button:
			audio_button.pressed.connect(_navigate_to.bind(audio_settings))
		if controls_button:
			controls_button.pressed.connect(_navigate_to.bind(controls_settings))
		if language_button:
			language_button.pressed.connect(_navigate_to.bind(language_settings))
	
	# Play title music when on main menu
	AudioManager.play_title_music()

func _show_panel(panel: Control) -> void:
	if panel:
		panel.visible = true

func _update_back_button() -> void:
	if back_button:
		back_button.visible = nav_stack.size() > 0

func _navigate_to(panel: Control) -> void:
	if not panel:
		return
	
	if current_panel:
		nav_stack.append(current_panel)
		current_panel.visible = false
	
	current_panel = panel
	_show_panel(current_panel)
	_update_back_button()

func _on_back_pressed() -> void:
	if nav_stack.is_empty():
		return
	
	current_panel.visible = false
	current_panel = nav_stack.pop_back()
	_show_panel(current_panel)
	_update_back_button()
	SettingsManager.save_settings()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mode_select.tscn")

func _on_achievements_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/achievement_book.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
