extends Node

var board_size: int
var board_height: int



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	board_size = $Board.texture.get_width()
	board_height = $Board.texture.get_height()
	#print(board_size)
	#print(board_height)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		# looking for left click specifically and only when pressed not released
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# check if mouse-click is on the board
			if event.position.x < board_size:
				print(event.position)
			
