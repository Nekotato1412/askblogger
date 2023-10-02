extends Panel
signal done


func _on_SizeForm_set_size(size):
	OS.window_size = size
	OS.center_window()
	emit_signal("done")
	hide()


func _on_SizeForm_show_error(message):
	if (message.length() == 0):
		$Container/ErrorLabel.hide()
	else:
		$Container/ErrorLabel.text = message
		$Container/ErrorLabel.show()
