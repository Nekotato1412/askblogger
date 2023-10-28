extends Control
signal open_folder




func _on_Close_button_up():
	hide()


func _on_OpenFolder_button_up():
	emit_signal("open_folder")
	hide()

func _on_Main_save_success():
	show()
