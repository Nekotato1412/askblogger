extends Control

signal text_changed
signal save


func _on_FileName_text_changed(new_text):
	emit_signal("text_changed", new_text)

func _on_Save_button_up():
	emit_signal("save")
	hide()

func _on_Open_button_up():
	show()
