extends CharacterBody2D

# Animation references
@onready var animation_player = $AnimationPlayer  # Adjust path if needed
@onready var sprite = $Sprite2D  # Adjust path if needed

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

func _ready() -> void:
	start_position = position
	target_position = position
	choose_random_action()

func _physics_process(delta: float) -> void:
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
		current_action = "move_left"
		action_duration = randf_range(0.8, 2.0)
		
		# Calculate safe left position
		var left_offset = randf_range(20.0, max_left_distance)
		target_position = start_position + Vector2(-left_offset, 0)
		
		# Clamp to boundaries
		var current_offset = position.x - start_position.x
		if current_offset <= -max_left_distance:
			# Already at left boundary, go idle instead
			current_action = "idle"
			play_animation("idle_down")
		else:
			play_animation("move_left")
	
	else:
		# Move right
		current_action = "move_right"
		action_duration = randf_range(0.8, 2.0)
		
		# Calculate safe right position
		var right_offset = randf_range(20.0, max_right_distance)
		target_position = start_position + Vector2(right_offset, 0)
		
		# Clamp to boundaries
		var current_offset = position.x - start_position.x
		if current_offset >= max_right_distance:
			# Already at right boundary, go idle instead
			current_action = "idle"
			play_animation("idle_down")
		else:
			play_animation("move_right")

func move_towards_target(delta: float) -> void:
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
	if animation_player and animation_player.has_animation(anim_name):
		if animation_player.current_animation != anim_name:
			animation_player.play(anim_name)
