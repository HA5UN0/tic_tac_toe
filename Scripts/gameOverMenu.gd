extends CanvasLayer

# signal is a var that means it will be emitting something
signal restart

# when this button is press it will emit something
func _on_restart_button_pressed() -> void:
	restart.emit()
