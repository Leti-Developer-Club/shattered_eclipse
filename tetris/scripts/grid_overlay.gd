extends Node2D

# Grid configuration
var columns: int = 10
var rows: int = 20
var cell_size: int = 32
var grid_offset: Vector2 = Vector2(32, 32)  # Starting position (1, 1) in tile coords

# Grid appearance
var line_color: Color = Color(0, 0, 0, 0.3)  # Black semi-transparent
var line_width: float = 2.0

func _ready() -> void:
	z_index = 10  # Draw on top
	queue_redraw()

func _draw() -> void:
	# Draw vertical lines
	for i in range(columns + 1):
		var x = grid_offset.x + (i * cell_size)
		var start = Vector2(x, grid_offset.y)
		var end = Vector2(x, grid_offset.y + (rows * cell_size))
		draw_line(start, end, line_color, line_width)
	
	# Draw horizontal lines
	for i in range(rows + 1):
		var y = grid_offset.y + (i * cell_size)
		var start = Vector2(grid_offset.x, y)
		var end = Vector2(grid_offset.x + (columns * cell_size), y)
		draw_line(start, end, line_color, line_width)
