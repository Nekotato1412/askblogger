extends Panel




func _on_Tabs_tab_changed(tab):
	for child in get_children():
		if (child.is_in_group("tab_" + str(tab))):
			child.show()
		else:
			child.hide()
