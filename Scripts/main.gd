extends Node

@export var circle_scene : PackedScene
@export var cross_scene : PackedScene

var temp_marker 
var player
var moves : int # count total moves
var winner : int
var player_panel_pos : Vector2i
var grid_data : Array
var grid_pos : Vector2i
var board_size : int
var board_height : int
var cell_size : int
var row_sum : int
var col_sum : int
var diagonal1_sum : int
var diagonal2_sum : int
var circleScore : int
var crossScore : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	board_size = $Board.texture.get_width()
	board_height = $Board.texture.get_height()
	#print(board_size)
	#print(board_height)
	#$gameOverMenu.visible = false
	
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
					moves += 1
					grid_data[grid_pos.y][grid_pos.x] = player
					#place that players marker
					create_marker(player, grid_pos * cell_size + Vector2i(cell_size / 2, cell_size / 2))
					if check_win() != 0:
						print("Game Over")
						get_tree().paused = true
						$gameOverMenu.show()
						if winner == 1:
							$gameOverMenu.get_node("resultLabel").text = "Player 1 Wins!"
							updateScoreBoard(1, 0)
							$scoreBoard/scorePanel/circleScore.text = "circle score: " + str(circleScore)
							print("player 1 wins")
							print(crossScore, circleScore)
						elif winner == -1:
							$gameOverMenu.get_node("resultLabel").text = "Player 2 Wins!"
							updateScoreBoard(0, 1)
							$scoreBoard/scorePanel/crossScore.text = "cross score: " + str(crossScore)
							print("player 2 wins")
							print(crossScore, circleScore)
					# check if board has arleady been filled
					elif moves == 9:
						print("Game Over, Tie")
						$gameOverMenu.get_node("resultLabel").text = "Tie Game!"
						get_tree().paused = true
						$gameOverMenu.show()
					player *= -1
					# update the panel marker
					temp_marker.queue_free() # clears previous marker first
					create_marker(player, player_panel_pos + Vector2i(cell_size / 2, cell_size / 2), true)
					print(grid_data)
				else:
					print("something is already here")
			
# -------------------------------------------------------- #
func new_game():
	player = 1
	moves = 0
	winner = 0
	grid_data = [
		[0,0,0],
		[0,0,0],
		[0,0,0]
	]
	# resets vars
	row_sum = 0
	col_sum = 0
	diagonal1_sum = 0
	diagonal2_sum = 0
	# clear existing markers
	get_tree().call_group("circleGroup", "queue_free")
	get_tree().call_group("crossGroup", "queue_free")
	# create a marker to show stating player's turn
	create_marker(player, player_panel_pos + Vector2i(cell_size / 2, cell_size / 2), true)
	$gameOverMenu.hide()
	# unpause game! lets goo!
	get_tree().paused = false


# -------------------------------------------------------- #
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

func check_win():
	# add up the markers in each row, column and diagonal
	for i in len(grid_data):
		row_sum = grid_data[i][0] + grid_data[i][1] + grid_data[i][2]
		col_sum = grid_data[0][i] + grid_data[1][i] + grid_data[2][i]
		diagonal1_sum = grid_data[0][0] + grid_data[1][1] + grid_data[2][2]
		diagonal2_sum = grid_data[0][2] + grid_data[1][1] + grid_data[2][0]
		# check if either player has win con
		if row_sum == 3 or col_sum == 3 or diagonal1_sum == 3 or diagonal2_sum == 3:
			winner = 1
		elif row_sum == -3 or col_sum == -3 or diagonal1_sum == -3 or diagonal2_sum == -3:
			winner = -1
	return winner


func _on_game_over_menu_restart() -> void:
	new_game()

func updateScoreBoard(p1, p2):
	circleScore += p1
	crossScore += p2
