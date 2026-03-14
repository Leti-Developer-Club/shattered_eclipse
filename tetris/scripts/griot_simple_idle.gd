extends Node2D

# Animation references (adjust paths to match your scene structure)
@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D  # If you need to flip sprite

# Movement boundaries (relative to starting position)
var start_position: Vector2
var max_left_distance: float = 50.0
var max_right_distance: float = 50.0

# Behavior timing
var action_timer: float = 0.0
var action_duration: float = 0.0
var current_action: String = "idle"

# Movement
var move_speed: float = 20.0
var is_moving: bool = false
var move_direction: int = 0  # -1 for left, 1 for right, 0 for idle

func _ready() -> void:
	start_position = position
	choose_random_action()

func _process(delta: float) -> void:
	action_timer += delta
	
	# Check if current action is complete
	if action_timer >= action_duration:
		choose_random_action()
	
	# Move if needed
	if is_moving:
		var new_x = position.x + (move_direction * move_speed * delta)
		
		# Clamp to boundaries
		var min_x = start_position.x - max_left_distance
		var max_x = start_position.x + max_right_distance
		new_x = clamp(new_x, min_x, max_x)
		
		position.x = new_x
		
		# Stop if reached boundary
		if new_x <= min_x or new_x >= max_x:
			is_moving = false
			play_animation("idle_down")

func choose_random_action() -> void:
	action_timer = 0.0
	
	# Random action: 40% idle, 30% move left, 30% move right
	var rand = randf()
	
	if rand < 0.4:
		# Idle
		current_action = "idle"
		action_duration = randf_range(1.5, 3.5)
		is_moving = false
		move_direction = 0
		play_animation("idle_down")
		
	elif rand < 0.7:
		# Move left
		var current_offset = position.x - start_position.x
		
		# Check if already at left boundary
		if current_offset <= -max_left_distance + 5:
			# Too far left, go idle or move right
			if randf() < 0.5:
				current_action = "idle"
				action_duration = randf_range(1.0, 2.0)
				is_moving = false
				play_animation("idle_down")
			else:
				# Move right instead
				current_action = "move_right"
				action_duration = randf_range(0.8, 2.0)
				is_moving = true
				move_direction = 1
				play_animation("move_right")
		else:
			current_action = "move_left"
			action_duration = randf_range(0.8, 2.0)
			is_moving = true
			move_direction = -1
			play_animation("move_left")
	
	else:
		# Move right
		var current_offset = position.x - start_position.x
		
		# Check if already at right boundary
		if current_offset >= max_right_distance - 5:
			# Too far right, go idle or move left
			if randf() < 0.5:
				current_action = "idle"
				action_duration = randf_range(1.0, 2.0)
				is_moving = false
				play_animation("idle_down")
			else:
				# Move left instead
				current_action = "move_left"
				action_duration = randf_range(0.8, 2.0)
				is_moving = true
				move_direction = -1
				play_animation("move_left")
		else:
			current_action = "move_right"
			action_duration = randf_range(0.8, 2.0)
			is_moving = true
			move_direction = 1
			play_animation("move_right")

func play_animation(anim_name: String) -> void:
	if animation_player and animation_player.has_animation(anim_name):
		if animation_player.current_animation != anim_name:
			animation_player.play(anim_name)
