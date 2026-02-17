extends Node2D

var i_tetromino: Array = [
	[Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1)], # 0 degrees
	[Vector2i(2, 0), Vector2i(2, 1), Vector2i(2, 2), Vector2i(2, 3)], # 90 degrees
	[Vector2i(0, 2), Vector2i(1, 2), Vector2i(2, 2), Vector2i(3, 2)], # 180 degrees
	[Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(1, 3)]  # 270 degrees
]
 
var t_tetromino: Array = [
	[Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)], # 0 degrees
	[Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)], # 90 degrees
	[Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)], # 180 degrees
	[Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2)]  # 270 degrees
]
 
var o_tetromino: Array = [
	[Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)], # All rotations are the same
	[Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)], # All rotations are the same
	[Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)], # All rotations are the same
	[Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]  # All rotations are the same
]
 
var z_tetromino: Array = [
	[Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1)], # 0 degrees
	[Vector2i(2, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)], # 90 degrees
	[Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2), Vector2i(2, 2)], # 180 degrees
	[Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(0, 2)]  # 270 degrees
]
 
var s_tetromino: Array = [
	[Vector2i(1, 0), Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1)], # 0 degrees
	[Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(2, 2)], # 90 degrees
	[Vector2i(1, 1), Vector2i(2, 1), Vector2i(0, 2), Vector2i(1, 2)], # 180 degrees
	[Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2)]  # 270 degrees
]
 
var l_tetromino: Array = [
	[Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)], # 0 degrees
	[Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(2, 2)], # 90 degrees
	[Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(0, 2)], # 180 degrees
	[Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2)]  # 270 degrees
]
 
var j_tetromino: Array = [
	[Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)], # 0 degrees
	[Vector2i(1, 0), Vector2i(2, 0), Vector2i(1, 1), Vector2i(1, 2)], # 90 degrees
	[Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(2, 2)], # 180 degrees
	[Vector2i(1, 0), Vector2i(1, 1), Vector2i(0, 2), Vector2i(1, 2)]  # 270 degrees
]


var tetrominoes: Array = [ j_tetromino, l_tetromino, 
							s_tetromino, z_tetromino, 
							t_tetromino, i_tetromino,
							o_tetromino,
]
var all_tetrominoes: Array = tetrominoes.duplicate()

var columns := 10
var rows := 20

var start_position: Vector2i = Vector2i( 5, 1 )
var cur_position: Vector2i

var fall_timer := 0.0
var fall_interval := 1.0
var fast_fall_multiplier := 10.0

var cur_tetromino_type: Array
var next_tetromino_type: Array
var rotation_index: int = 0
var active_tetromino: Array = []

var title_id: int = 0
var piece_atlas : Vector2i
var next_piece_atlas : Vector2i

var score : int
var level: int = 0
var lines_cleared: int = 0
var is_game_running: bool
var is_story_mode: bool = false  # Track if playing story mode 

@onready var board: TileMapLayer = $board
@onready var active: TileMapLayer = $active

func _ready() -> void:
	$game_hud/end_panel/new_game_button.pressed.connect( start_new_game )
	$game_hud/end_panel/main_menu_button.pressed.connect( _on_main_menu_pressed )
	
	# Check if we're in story mode
	if get_tree().root.has_meta("is_story_mode"):
		is_story_mode = get_tree().root.get_meta("is_story_mode")
	
	# Update button text for story mode
	if is_story_mode:
		$game_hud/end_panel/new_game_button.text = "RETRY LEVEL"
	
	start_new_game()
	$game_hud/end_panel.visible = false
	$game_hud/griot_cry.visible = false



func start_new_game() -> void:
	var saved_level = level
	var saved_score = score
	var saved_lines = lines_cleared
	
	score = 0
	level = 0
	lines_cleared = 0
	is_game_running = true
	
	# Load saved progress if in story mode
	if is_story_mode:
		if get_tree().root.has_meta("story_progress_data"):
			# Loading from save
			var progress = get_tree().root.get_meta("story_progress_data")
			get_tree().root.remove_meta("story_progress_data")
			
			if progress.has("level"):
				level = progress.level
				lines_cleared = progress.lines_cleared
				score = progress.score
		else:
			# Retrying current level (after game over)
			level = saved_level
			lines_cleared = saved_lines
			score = saved_score
	
	$game_hud/end_panel.visible = false
	
	# Show normal Griot, hide crying Griot
	$game_hud/griot.visible = true
	$game_hud/griot_cry.visible = false
	
	# Play gameplay music
	AudioManager.play_gameplay_music()
	
	# Update background based on level
	update_background()

	update_hud()
	clear_board()
	clear_tetromino()
	next_tetromino_preview()
	cur_tetromino_type = choose_tetromino()
	piece_atlas = Vector2i( all_tetrominoes.find( cur_tetromino_type), 0 )
	next_tetromino_type = choose_tetromino()
	next_piece_atlas = Vector2i( all_tetrominoes.find( next_tetromino_type), 0 )
	initialize_tetrominoes()
	
func _physics_process(delta: float) -> void:
	if is_game_running:
		var move_direction = Vector2i.ZERO
		
		if Input.is_action_just_pressed("ui_left"):
			move_direction = Vector2i.LEFT
		elif Input.is_action_just_pressed("ui_right"):
			move_direction = Vector2i.RIGHT
		
		if move_direction != Vector2i. ZERO:
			move_tetromino( move_direction )
			
		if Input.is_action_just_pressed("ui_up"):
			rotate_tetromino()
		
		var cur_fall_interval = get_fall_speed()
		if Input.is_action_pressed("ui_down"):
			cur_fall_interval /= fast_fall_multiplier
		
		fall_timer += delta
		if fall_timer >= cur_fall_interval:
			move_tetromino( Vector2i.DOWN)
			fall_timer = 0
	
func choose_tetromino() -> Array:
	var selected_tetromino: Array
	if not tetrominoes.is_empty():
		tetrominoes.shuffle()
		selected_tetromino = tetrominoes.pop_front()
	else:
		tetrominoes = all_tetrominoes.duplicate()
		tetrominoes.shuffle()
		selected_tetromino = tetrominoes.pop_front()
	return selected_tetromino

func initialize_tetrominoes() -> void:
	cur_position = start_position
	active_tetromino = cur_tetromino_type[ rotation_index ]
	render_tetromino( active_tetromino, cur_position, piece_atlas )
	render_tetromino( next_tetromino_type[ 0 ], Vector2i( 15, 2 ), next_piece_atlas )

func render_tetromino( tetromino: Array, _position: Vector2i, atlas: Vector2i) -> void:
	for block in tetromino:
		active.set_cell( _position + block, title_id, atlas )

func clear_tetromino() -> void:
	for block in active_tetromino:
		active.erase_cell( cur_position + block)

func move_tetromino( direction: Vector2i ) -> void:
	if is_valid_move( direction ):
		clear_tetromino()
		cur_position += direction
		render_tetromino( active_tetromino, cur_position, piece_atlas)
	else: 
		if direction == Vector2i.DOWN:
			land_tetromino()
			check_rows()
			
			cur_tetromino_type = next_tetromino_type
			piece_atlas = next_piece_atlas
			next_tetromino_type = choose_tetromino()
			next_piece_atlas = Vector2i( all_tetrominoes.find( next_tetromino_type), 0 )
			next_tetromino_preview()
			initialize_tetrominoes()
			is_game_over()
	pass

func land_tetromino() -> void:
	for i in active_tetromino:
		active.erase_cell( cur_position + i )
		board.set_cell( cur_position + i, title_id, piece_atlas )

func next_tetromino_preview() -> void:
	for i in range( 14, 19 ):
		for j in range( 2, 6 ):
			active.erase_cell( Vector2i( i, j ) )

func check_rows() -> void:
	var row: int = rows
	var rows_cleared_this_time: int = 0
	var rows_to_clear: Array = []
	
	while row > 0:
		var cells_finished:= 0
		for i in range( columns ):
			if not is_within_bounds( Vector2i( i +1, row )):
				cells_finished += 1
		if cells_finished == columns:
			rows_to_clear.append(row)
			rows_cleared_this_time += 1
			row -= 1
		else: 
			row -= 1
	
	if rows_cleared_this_time > 0:
		# Blink animation for any line clear
		await blink_rows(rows_to_clear)
		
		# Clear the rows
		for cleared_row in rows_to_clear:
			shift_rows(cleared_row)
		
		lines_cleared += rows_cleared_this_time
		score += calculate_score(rows_cleared_this_time)
		update_level()
		update_hud()
		
		# Play line clear sound effect
		AudioManager.play_line_clear_sfx()

func blink_rows(rows_to_blink: Array) -> void:
	var blink_count = 2
	var blink_duration = 0.05
	
	# Store original cell data
	var original_cells = {}
	for row in rows_to_blink:
		for col in range(columns):
			var cell_pos = Vector2i(col + 1, row)
			var atlas = board.get_cell_atlas_coords(cell_pos)
			original_cells[cell_pos] = atlas
	
	for blink in range(blink_count):
		# Hide rows (erase cells)
		for row in rows_to_blink:
			for col in range(columns):
				var cell_pos = Vector2i(col + 1, row)
				board.erase_cell(cell_pos)
		
		await get_tree().create_timer(blink_duration).timeout
		
		# Show rows with original colors
		for row in rows_to_blink:
			for col in range(columns):
				var cell_pos = Vector2i(col + 1, row)
				if original_cells.has(cell_pos):
					var atlas = original_cells[cell_pos]
					if atlas != Vector2i(-1, -1):
						board.set_cell(cell_pos, title_id, atlas)
		
		await get_tree().create_timer(blink_duration).timeout

func shift_rows(row) -> void:
	var atlas: Vector2i
	for i in range( row, 1, -1 ):
		for j in range( columns):
			atlas = board.get_cell_atlas_coords( Vector2i( j + 1, i - 1 ))
			if atlas == Vector2i( -1, 1 ):
				board.erase_cell( Vector2i( j +1, i))
			else: 
				board.set_cell( Vector2i( j + 1, i), title_id, atlas )

func rotate_tetromino() -> void:
	if is_valid_rotation():
		clear_tetromino()
		rotation_index = ( rotation_index + 1 ) % 4
		active_tetromino = cur_tetromino_type[ rotation_index ]
		render_tetromino( active_tetromino, cur_position, piece_atlas)
	pass


func is_valid_move( new_position: Vector2i ) -> bool:
	for block in active_tetromino:
		if not is_within_bounds( cur_position + block + new_position):
			return false
	return true

func is_valid_rotation() -> bool:
	var next_rotation = ( rotation_index + 1 ) % 4
	var rotated_tetromino = cur_tetromino_type[ next_rotation ]
	
	for block in rotated_tetromino:
		if not is_within_bounds( cur_position + block ):
			return false
	return true
	
func is_within_bounds( pos: Vector2i ) -> bool:
	if pos.x < 0 or pos.x >= columns + 1 or pos.y < 0 or pos.y >= rows + 1:
		return false
	
	var tile_id = board.get_cell_source_id( pos )
	return tile_id == -1

func clear_board() -> void:
	for i in range(rows):
		for j in range(columns):
			board.erase_cell( Vector2i( j+1, i+1))

func is_game_over() -> void:
	for i in active_tetromino:
		if not is_within_bounds( i + cur_position):
			land_tetromino()
			$game_hud/end_panel.visible = true
			
			# Save story progress if in story mode
			if is_story_mode:
				AchievementManager.save_story_progress(level, score, lines_cleared)
			
			# Hide normal Griot and show crying Griot
			$game_hud/griot.visible = false
			$game_hud/griot_cry.visible = true
			
			# Play cry animation
			if $game_hud/griot_cry.has_node("AnimatedSprite2D"):
				$game_hud/griot_cry.get_node("AnimatedSprite2D").play("game_over_cry")
			
			# Play game over music
			AudioManager.play_gameover_music()

			is_game_running = false

func _on_main_menu_pressed() -> void:
	# Return to title music when going back to main menu
	AudioManager.play_title_music()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

# Calculate score based on lines cleared at once
func calculate_score(lines_cleared_at_once: int) -> int:
	match lines_cleared_at_once:
		1: return 40 * (level + 1)
		2: return 100 * (level + 1)
		3: return 300 * (level + 1)
		4: return 1200 * (level + 1)
	return 0

# Update level based on total lines cleared (every 10 lines)
func update_level() -> void:
	var new_level = lines_cleared / 10
	if new_level != level:
		level = new_level
		
		# Update background based on new level
		update_background()
		
		# Check if story mode is complete (reached level 5)
		if is_story_mode and level >= 5:
			# Story mode complete! Show victory screen
			get_tree().change_scene_to_file("res://scenes/story_complete.tscn")
			return
		
		# Play level up sound effect
		AudioManager.play_level_up_sfx()
		
		# Check for achievement unlocks (Story Mode only)
		if is_story_mode:
			var unlocked = AchievementManager.check_and_unlock_achievements(level)
			for achievement in unlocked:
				show_achievement_notification(achievement)

# Update background visibility based on current level
func update_background() -> void:
	# Hide all backgrounds first
	$Background_lv1.visible = false
	$Background_lv2.visible = false
	$Background_lv3.visible = false
	$Background_lv4.visible = false
	$Background_lv5.visible = false
	
	# Show the appropriate background based on level
	if level == 0:
		$Background_lv1.visible = true
	elif level == 1:
		$Background_lv2.visible = true
	elif level == 2:
		$Background_lv3.visible = true
	elif level == 3:
		$Background_lv4.visible = true
	elif level >= 4:
		$Background_lv5.visible = true

# Get fall speed based on current level
func get_fall_speed() -> float:
	if level <= 9:
		return 0.8 - (level * 0.07)
	elif level <= 18:
		return 0.1
	else:
		return 0.05

# Update all HUD labels
func update_hud() -> void:
	$game_hud/huge_panel/score_label.text = "SCORE: " + str(score)
	$game_hud/huge_panel/lines_cleared.text = "LINES: " + str(lines_cleared)
	$game_hud/huge_panel/level.text = "LEVEL: " + str(level)

# Show achievement unlock notification
func show_achievement_notification(achievement: Dictionary) -> void:
	# Load Orbitron Black font
	var orbitron_black = load("res://assets/Orbitron/static/Orbitron-Black.ttf")
	
	# Create a simple notification label
	var notification = Label.new()
	notification.text = "Achievement Unlocked!\n" + achievement.name
	notification.add_theme_font_override("font", orbitron_black)
	notification.add_theme_font_size_override("font_size", 24)
	notification.add_theme_color_override("font_color", Color(0, 0, 0, 1))  # Black color
	notification.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	notification.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Position it in the center
	notification.position = Vector2(2, 3)
	notification.size = Vector2(400, 100)
	notification.z_index = 100
	
	add_child(notification)
	
	# Fade out and remove after 3 seconds
	var tween = create_tween()
	tween.tween_property(notification, "modulate:a", 0.0, 1.0).set_delay(2.0)
	tween.tween_callback(notification.queue_free)
