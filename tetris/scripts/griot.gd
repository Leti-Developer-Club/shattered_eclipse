extends CharacterBody2D

# Reference to the AnimatedSprite2D
@onready var animated_sprite = $AnimatedSprite2D

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
var target_position: Vector2

# State control
var is_active: bool = true

func _ready() -> void:
	start_position = position
	target_position = position
	choose_random_action()

func _physics_process(delta: float) -> void:
	if not is_active:
		return
		
	action_timer += delta
	
	# Check if current action is complete
	if action_timer >= action_duration:
		choose_random_action()
	
	# Execute current action
	match current_action:
		"move_left":
			move_towards_target(delta)
		"move_right":
			move_towards_target(delta)
		"idle":
			velocity = Vector2.ZERO
	
	move_and_slide()

func play_game_over_cry() -> void:
	is_active = false
	velocity = Vector2.ZERO
	if animated_sprite.sprite_frames.has_animation("griot_cry"):
		animated_sprite.play("griot_cry")
	else:
		# Fallback if animation doesn't exist
		animated_sprite.play("idle_down")

func choose_random_action() -> void:
	action_timer = 0.0
	
	# Random action: 40% idle, 30% move left, 30% move right
	var rand = randf()
	
	if rand < 0.4:
		# Idle
		current_action = "idle"
		action_duration = randf_range(1.5, 3.5)
		play_animation("idle_down")
		target_position = position
		
	elif rand < 0.7:
		# Move left
		var current_offset = position.x - start_position.x
		
		# Check if already at left boundary
		if current_offset <= -max_left_distance + 5:
			# Too far left, choose different action
			choose_idle_or_opposite("right")
		else:
			current_action = "move_left"
			action_duration = randf_range(0.8, 2.0)
			
			# Calculate safe left position
			var left_offset = randf_range(20.0, 40.0)
			target_position.x = clamp(
				position.x - left_offset,
				start_position.x - max_left_distance,
				start_position.x + max_right_distance
			)
			target_position.y = start_position.y
			
			play_animation("move_left")
	
	else:
		# Move right
		var current_offset = position.x - start_position.x
		
		# Check if already at right boundary
		if current_offset >= max_right_distance - 5:
			# Too far right, choose different action
			choose_idle_or_opposite("left")
		else:
			current_action = "move_right"
			action_duration = randf_range(0.8, 2.0)
			
			# Calculate safe right position
			var right_offset = randf_range(20.0, 40.0)
			target_position.x = clamp(
				position.x + right_offset,
				start_position.x - max_left_distance,
				start_position.x + max_right_distance
			)
			target_position.y = start_position.y
			
			play_animation("move_right")

func choose_idle_or_opposite(opposite_direction: String) -> void:
	if randf() < 0.5:
		# Go idle
		current_action = "idle"
		action_duration = randf_range(1.0, 2.0)
		play_animation("idle_down")
		target_position = position
	else:
		# Move in opposite direction
		if opposite_direction == "left":
			current_action = "move_left"
			action_duration = randf_range(0.8, 2.0)
			var left_offset = randf_range(20.0, 40.0)
			target_position.x = clamp(
				position.x - left_offset,
				start_position.x - max_left_distance,
				start_position.x + max_right_distance
			)
			target_position.y = start_position.y
			play_animation("move_left")
		else:
			current_action = "move_right"
			action_duration = randf_range(0.8, 2.0)
			var right_offset = randf_range(20.0, 40.0)
			target_position.x = clamp(
				position.x + right_offset,
				start_position.x - max_left_distance,
				start_position.x + max_right_distance
			)
			target_position.y = start_position.y
			play_animation("move_right")

func move_towards_target(_delta: float) -> void:
	var direction = (target_position - position).normalized()
	
	# Check if reached target
	if position.distance_to(target_position) < 2.0:
		velocity = Vector2.ZERO
		position = target_position
		# Switch to idle after reaching target
		current_action = "idle"
		play_animation("idle_down")
		action_timer = action_duration  # Force new action next frame
	else:
		velocity = direction * move_speed

func play_animation(anim_name: String) -> void:
	if animated_sprite.sprite_frames.has_animation(anim_name):
		if animated_sprite.animation != anim_name:
			animated_sprite.play(anim_name)
