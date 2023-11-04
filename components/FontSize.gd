extends LineEdit
signal font_size_changed


onready var old_text = text
onready var new_size = int(text)


func _on_FontSize_text_entered(new_text):
	validate_text(new_text)

func validate_text(new_text):
	if (int(new_text) == 0):
		text = old_text
		return

	old_text = new_text
	new_size = clamp(int(new_text), 10, 24)
	text = str(new_size)

func _on_main_font_size_changed(size):
	self.placeholder_text = str(size)

func _on_Confirm_button_up():
	if (int(text) > 0 or text != ""):
		emit_signal("font_size_changed", new_size)


func _on_FontSize_focus_exited():
	validate_text(self.text)
