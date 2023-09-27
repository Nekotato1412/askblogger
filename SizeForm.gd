extends VBoxContainer
signal set_size
signal show_error


func _on_Confirm_button_up():
	var chosen_size = $Presets.get_chosen_size()
	var screen_size = OS.get_screen_size()
	
	if (chosen_size.x == 0 or chosen_size.y == 0):
		emit_signal("show_error", "Invalid resolution.")
		return
	
	if (chosen_size.x > screen_size.x or chosen_size.y > screen_size.y):
		var error_string = "That resolution is too big. (>{width} x {height})"
		error_string = error_string.format({"width": screen_size.x, "height": screen_size.y})
		
		emit_signal("show_error", error_string)
		return

	emit_signal("show_error", "")
	emit_signal("set_size", chosen_size)
