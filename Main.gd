extends Control

signal presentation_mode
signal edit_mode
signal setup_mode

enum MODES {
	PRESENTATION,
	EDIT,
	SETUP
}

const Images:Dictionary = {
	"background": "BackgroundLayer/Background",
	"portrait": "PortraitLayer/PortraitBox/Texture",
	"dialog": "DialogLayer/DialogBox/TextureRect"
}

var _image = ""
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
	img.save_png("user://blog.png")
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
	$Super/FileDialog.show()
	
func _on_image_selected(path):
	var image = Image.new()
	var err = image.load(path)
	if (err != 0):
		$Super/FileDialog.hide()
		return
	
	# Yup, this causes a memory leak. Too bad!
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
	get_node(_image).texture = texture
	
	$Super/FileDialog.hide()
func _on_image_change(identifier: String):
	change_image(identifier)

