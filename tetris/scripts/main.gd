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
var clear_reward: int = 130
var is_game_running: bool 

@onready var board: TileMapLayer = $board
@onready var active: TileMapLayer = $active

func _ready() -> void:
	$game_hud/new_game_button.pressed.connect( start_new_game )
	start_new_game()
	$game_hud/new_game_button.visible = false



func start_new_game() -> void:
	score = 0
	is_game_running = true
	
	$game_hud/game_over_label.visible = false
	$game_hud/new_game_button.visible = false

	clear_board()
	clear_tetromino()
	next_tetromino_preview() #wahala dey
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
		
		var cur_fall_interval = fall_interval
		if Input.is_action_just_pressed("ui_down"):
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
	while row > 0:
		var cells_finished:= 0
		for i in range( columns ):
			if not is_within_bounds( Vector2i( i +1, row )):
				cells_finished += 1
		if cells_finished == columns:
				shift_rows( row )
				score += clear_reward
				$game_hud/score_label.text = "Score: " + str( score )
		else: 
				row -= 1

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
		rotation_index = ( rotation_index -1 ) % 4
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
			$game_hud/game_over_label.visible = true
			$game_hud/new_game_button.visible = true

			is_game_running = false
