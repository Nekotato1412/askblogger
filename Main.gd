extends Control

signal presentation_mode
signal edit_mode
signal setup_mode
signal font_change
signal font_size_change
signal set_outline
signal update_preference

signal save_success
signal save

enum MODES {
	PRESENTATION,
	EDIT,
	SETUP
}

const Images:Dictionary = {
	"background": "BackgroundLayer/Background",
	"portrait": "PortraitLayer/Portrait",
	"dialog": "DialogLayer/DialogBox/TextureRect"
}

var _image = ""
var _image_name = "blog"
var _font = ""
var _mode = MODES.EDIT

var _exports_location: String

var Preferences: SaveData

func _ready():
	# Initialization
	for control in $UILayer.get_children():
		if control.is_in_group("image_changer"):
			control.connect("image_change", self, "_on_image_change")

func _on_DataManager_data_loaded():
	Preferences = $DataManager.get_data()
	_exports_location = $DataManager.get_exports_location()

func presentation_mode():
	_mode = MODES.PRESENTATION
	emit_signal("presentation_mode")
	# warning-ignore:return_value_discarded
	get_tree().create_timer(0.1).connect("timeout", self, "snapshot")
	emit_signal("save")
	
func edit_mode():
	_mode = MODES.EDIT
	emit_signal("edit_mode")

func setup_mode():
	_mode = MODES.SETUP
	emit_signal("setup_mode")

func snapshot():
	var img = get_viewport().get_texture().get_data()
	img.flip_y()
	img.save_png(_exports_location + _image_name + ".png")
	# warning-ignore:return_value_discarded
	edit_mode()
	if (Preferences.get_flag("autoopen")):
		emit_signal("save_success")

func open_folder():
	OS.shell_open(str("file://" + OS.get_user_data_dir()))

func _process(_delta):
	if Input.is_action_just_released("ui_cancel"):
		if _mode == MODES.SETUP:
			edit_mode()

func _on_PresentationMode_button_up():
	presentation_mode()

func _on_SetupMode_button_up():
	setup_mode()

func change_image(which: String):
	_image = Images.get(which)
	$Super/ImageDialog.show()
	
func _on_image_selected(path):
	var texture = $DataManager.update_image(path)
	get_node(_image).change_texture(texture)
	$Super/ImageDialog.hide()
	
	$DataManager.update_rects()
	
func _on_image_change(identifier: String):
	change_image(identifier)

func change_font():
	$Super/FontDialog.show()

func change_font_size(new_size: int):
	emit_signal("font_size_change", new_size)
	$DataManager.update_font_size(new_size)

func _on_font_selected(path):
	$Super/FontDialog.hide()
	var file_path = $DataManager.update_font(path)
	emit_signal("font_change", file_path)

func _on_font_change():
	change_font()

func _on_FileName_text_changed(new_text):
	_image_name = new_text

func _on_font_size_changed(size):
	change_font_size(size)

func _on_SettingsButton_button_up():
	$SettingsLayer/OptionsMenu.show()	

func _on_setup_mode():
	setup_mode()

func _on_preference_updated(name, flag):
	$DataManager.update_flag(name, flag)
	if (name == "fontoutline"):
		# true/false will return 0 or 1
		emit_signal("set_outline", int(flag))

func _on_SaveDialog_save():
	presentation_mode()

func _on_DataManager_error_thrown(error):
	$Super/AcceptDialog.window_title = "Error"
	$Super/AcceptDialog.dialog_text = error
	$Super/AcceptDialog.popup_centered()


func _on_DataManager_font_change(font):
	emit_signal("font_change", font)

func _on_DataManager_font_size_change(size):
	emit_signal("font_size_change", size)

func _on_DataManager_set_outline(outline):
	emit_signal("set_outline", outline)

func _on_DataManager_update_preference(name, value):
	emit_signal("update_preference", name, value)
