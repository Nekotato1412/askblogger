extends VBoxContainer




func _on_OptionsMenu_font_outline(outline):
	$PreferencesOptions/FontOutline.pressed = bool(outline)


func _on_OptionsMenu_update_preference(name, flag):
	if (name == 'autoopen'):
		$PreferencesOptions/AutoOpen.pressed = flag
