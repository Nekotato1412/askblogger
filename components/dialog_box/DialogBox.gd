extends Node

func _on_Main_presentation_mode():
	$DialogContent._on_Main_presentation_mode()
	$LineEdit._on_Main_presentation_mode()
	
	for widget in $D_Widgets.get_children():
		widget._on_Main_presentation_mode()
	
	for widget in $N_Widgets.get_children():
		widget._on_Main_presentation_mode()

func _on_Main_edit_mode():
	$DialogContent._on_Main_edit_mode()
	$LineEdit._on_Main_edit_mode()
	
	for widget in $D_Widgets.get_children():
		widget._on_Main_edit_mode()
		
	for widget in $N_Widgets.get_children():
		widget._on_Main_edit_mode()

func _on_Main_setup_mode():
	$DialogContent._on_Main_setup_mode()
	$LineEdit._on_Main_setup_mode()
	
	for widget in $D_Widgets.get_children():
		widget._on_Main_setup_mode()
	
	for widget in $N_Widgets.get_children():
		widget._on_Main_setup_mode()

func _on_Main_font_change(path):
	$DialogContent._on_Main_font_change(path)
	$LineEdit._on_Main_font_change(path)

func _on_Main_font_size_change(size):
	$DialogContent._on_Main_font_size_change(size)
	$LineEdit._on_Main_font_size_change(size)
