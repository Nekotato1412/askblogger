extends Control
signal font_change
signal font_size_changed
signal setup_mode
signal preference_updated

# From Main
signal font_selected
signal main_font_size_changed
signal font_outline
signal update_preference

func _on_Close_button_up():
	hide()

func _on_font_size_changed(new_size):
	emit_signal("font_size_changed", new_size)

func _on_SetupMode_button_up():
	emit_signal("setup_mode")
	hide()

func _on_AddButton_button_up():
	emit_signal("font_change")

func _on_AutoOpen_toggled(button_pressed):
	emit_signal("preference_updated", "autoopen", button_pressed)

func _on_FontOutline_toggled(button_pressed):
	emit_signal("preference_updated", "fontoutline", button_pressed)

func _on_Main_font_change(path):
	emit_signal("font_selected", path)

func _on_ImageSize_set_size(new_size):
	OS.window_size = new_size
	OS.center_window()

func _on_Main_font_size_change(new_size):
	emit_signal("main_font_size_changed", new_size)


func _on_Main_set_outline(outline):
	emit_signal("font_outline", outline)

func _on_Main_update_preference(name, flag):
	emit_signal("update_preference", name, flag)
