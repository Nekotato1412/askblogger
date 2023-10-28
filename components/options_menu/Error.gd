extends Label





func _on_ImageSize_show_error(error):
	if (error):
		show()
		text = error
	else:
		hide()
