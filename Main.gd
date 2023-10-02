extends Control

signal presentation_mode
signal edit_mode
signal setup_mode
signal font_change

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
var _font = ""
var _save_name = "blog"
var _mode = MODES.EDIT

func _ready():
	for control in $UILayer.get_children():
		if control.is_in_group("image_changer"):
			control.connect("image_change", self, "_on_image_change")

func presentation_mode():
	_mode = MODES.PRESENTATION
	emit_signal("presentation_mode")
	# warning-ignore:return_value_discarded
	get_tree().create_timer(1).connect("timeout", self, "snapshot")
	
func edit_mode():
	_mode = MODES.EDIT
	emit_signal("edit_mode")

func setup_mode():
	_mode = MODES.SETUP
	emit_signal("setup_mode")

func snapshot():
	var img = get_viewport().get_texture().get_data()
	img.flip_y()
	img.save_png("user://" + _save_name + ".png")
	# warning-ignore:return_value_discarded
	OS.shell_open(str("file://" + OS.get_user_data_dir()))
	edit_mode()

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
	var image = Image.new()
	var err = image.load(path)
	if (err != 0):
		$Super/ImageDialog.hide()
		return
	
	# Yup, this causes a memory leak. Too bad!
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
	get_node(_image).change_texture(texture)
	
	$Super/ImageDialog.hide()
	
func _on_image_change(identifier: String):
	change_image(identifier)

func change_font():
	$Super/FontDialog.show()

func _on_font_selected(path):
	emit_signal("font_change", path)
	$Super/FontDialog.hide()

func _on_FontChange_button_up():
	change_font()

func _on_FileName_text_changed(new_text):
	_save_name = new_text
