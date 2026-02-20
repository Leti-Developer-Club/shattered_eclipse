extends Node

# This script automatically adds click sounds to all buttons in the scene tree

func _ready() -> void:
	# Wait for the scene to be fully loaded
	await get_tree().process_frame
	connect_all_buttons(get_tree().root)
	
	# Listen for scene changes
	get_tree().node_added.connect(_on_node_added)

func connect_all_buttons(node: Node) -> void:
	# Check if this node is a button
	if node is Button:
		# Connect to the pressed signal if not already connected
		if not node.pressed.is_connected(_on_button_pressed):
			node.pressed.connect(_on_button_pressed.bind(node), CONNECT_DEFERRED)
	
	# Recursively check all children
	for child in node.get_children():
		connect_all_buttons(child)

func _on_button_pressed(_button: Button) -> void:
	AudioManager.play_button_click_sfx()

# Connect to new buttons when they're added to the scene
func _on_node_added(node: Node) -> void:
	if node is Button:
		await get_tree().process_frame
		if not node.pressed.is_connected(_on_button_pressed):
			node.pressed.connect(_on_button_pressed.bind(node), CONNECT_DEFERRED)
