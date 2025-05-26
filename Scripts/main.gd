extends Node

@export var circle_scene : PackedScene
@export var cross_scene : PackedScene

var temp_marker 
var player
var player_panel_pos : Vector2i
var grid_data : Array
var grid_pos : Vector2i
var board_size : int
var board_height : int
var cell_size : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	board_size = $Board.texture.get_width()
	board_height = $Board.texture.get_height()
	#print(board_size)
	#print(board_height)
	
	# divide board size by 3 to get the size of individual cell
	cell_size = board_size / 3
	
	# get coordinates of small panel on right side of window
	player_panel_pos = $playerPanel.get_position()
	
	new_game()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		# looking for left click specifically and only when pressed not released
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# check if mouse-click is on the board
			if event.position.x < board_size:
				# convert mouse position into grid location
				grid_pos = Vector2i(event.position / cell_size)
				# check first to see if anything is there
				if grid_data[grid_pos.y][grid_pos.x] == 0:
					grid_data[grid_pos.y][grid_pos.x] = player
					#place that players marker
					create_marker(player, grid_pos * cell_size + Vector2i(cell_size / 2, cell_size / 2))
					player *= -1
					# update the panel marker
					temp_marker.queue_free() # clears previous marker first
					create_marker(player, player_panel_pos + Vector2i(cell_size / 2, cell_size / 2), true)
					print(grid_data)
				else:
					print("something is already here")
			

func new_game():
	player = 1
	grid_data = [
		[0,0,0],
		[0,0,0],
		[0,0,0]
	]
	# create a marker to show stating player's turn
	create_marker(player, player_panel_pos + Vector2i(cell_size / 2, cell_size / 2), true)

func create_marker(player, position, temp=false):
	# create a marker node and add it as a child
	if player == 1:
		var circle = circle_scene.instantiate()
		circle.position = position
		add_child(circle)
		if temp == true: temp_marker = circle
	else:
		var cross = cross_scene.instantiate()
		cross.position = position
		add_child(cross)
		if temp == true: temp_marker = cross
