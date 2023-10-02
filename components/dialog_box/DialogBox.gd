extends Node

func _on_Main_presentation_mode():
	$DialogContent._on_Main_presentation_mode()
	$LineEdit._on_Main_presentation_mode()
	$D_Scale_Widget_X._on_Main_presentation_mode()
	$D_Scale_Widget_Y._on_Main_presentation_mode()
	$N_Scale_Widget_X._on_Main_presentation_mode()
	$N_Scale_Widget_Y._on_Main_presentation_mode()

func _on_Main_edit_mode():
	$DialogContent._on_Main_edit_mode()
	$LineEdit._on_Main_edit_mode()
	$D_Scale_Widget_X._on_Main_edit_mode()
	$D_Scale_Widget_Y._on_Main_edit_mode()
	$N_Scale_Widget_X._on_Main_edit_mode()
	$N_Scale_Widget_Y._on_Main_edit_mode()

func _on_Main_setup_mode():
	$DialogContent._on_Main_setup_mode()
	$LineEdit._on_Main_setup_mode()
	$D_Scale_Widget_X._on_Main_setup_mode()
	$D_Scale_Widget_Y._on_Main_setup_mode()
	$N_Scale_Widget_X._on_Main_setup_mode()
	$N_Scale_Widget_Y._on_Main_setup_mode()
