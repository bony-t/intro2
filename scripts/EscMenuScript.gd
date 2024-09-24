extends Control

signal return_button_pressed

#unfreezes the game pressing the esc key does the same thing however this works aswell
func _on_return_to_game_button_pressed() -> void:
	emit_signal("return_button_pressed") # Emit the signal


func _on_settings_button_pressed() -> void:
	pass # Replace with function body.


func _on_close_game_button_pressed() -> void:
	# This will close the game
	get_tree().quit()
