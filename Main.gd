extends Control

signal presentation_mode
signal edit_mode
signal setup_mode
signal font_change
signal font_size_change

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

onready var dialog_rect = $DialogLayer/DialogBox/DialogContent.get_global_rect()
onready var name_rect = $DialogLayer/DialogBox/LineEdit.get_global_rect()

onready var dialog_path = $DialogLayer/DialogBox/DialogContent.get_path()
onready var name_path = $DialogLayer/DialogBox/LineEdit.get_path()

onready var portrait_rect = $PortraitLayer/Portrait.get_global_rect()
onready var portrait_path = $PortraitLayer/Portrait.get_path()

var _preferences_location = "user://data/"
var _images_location = "user://data/images/"
var _exports_location = "user://exports/"

onready var Preferences = SaveData.new()

func _ready():
	# Initialization
	for control in $UILayer.get_children():
		if control.is_in_group("image_changer"):
			control.connect("image_change", self, "_on_image_change")
	
	Preferences.set_save_name("preferences")
	

	var data_directory = Directory.new()	
	if (data_directory.open(_preferences_location) != OK):
		data_directory.make_dir(_preferences_location)
		var notice_file = File.new()
		notice_file.open(_preferences_location + "SECURITY_NOTICE.txt", File.WRITE)
		notice_file.store_string("THINK BEFORE YOU COPY. \n.tres files can contain executable code which means you SHOULD NOT SHARE OR DOWNLOAD this file.")
		notice_file.close()
	
	var image_directory = Directory.new()
	if (image_directory.open("user://data/images") != OK):
		image_directory.make_dir(_images_location)
	
	var exports_directory = Directory.new()
	if (exports_directory.open(_exports_location) != OK):
		exports_directory.make_dir(_exports_location)
	
	# Loading
	var error = Preferences.load_from_disk(_preferences_location)
	
	if (error == ERR_FILE_UNRECOGNIZED):
		$Super/AcceptDialog.window_title = "Error"
		$Super/AcceptDialog.dialog_text = "Preferences data could not be loaded. The file could not be recognized."
		$Super/AcceptDialog.popup_centered()
		init_save()
	
	if (error == ERR_FILE_NOT_FOUND):
		init_save()
	
	# TODO: Load data into components
	if (error == OK):
		# Textures
		for node_path in Preferences.image_paths.keys():
			var image_node = get_node(node_path)
			var texture = Preferences.get_image(node_path)
			
			if texture == null: continue
			
			image_node.change_texture(texture)
			
		
		# Font Info
		var font = Preferences.get_font_path("root")
		var font_size = Preferences.get_font_size("root")
		
		if (font != null and !font.empty()):
			emit_signal("font_change", font)
		
		if (font_size):
			emit_signal("font_size_change", font_size)
			
		# Text Content
		for node_path in Preferences.text_content.keys():
			var text_node = get_node(node_path)
			var text = Preferences.get_text(node_path)
			
			if (text != null and !text.empty()):
				text_node.text = text
		
		# Scale & Position
		for node_path in Preferences.rects.keys():
			var rect_node = get_node(node_path)
			var rect = Preferences.get_rect(node_path)
			rect_node.rect_global_position = rect.position
			rect_node.rect_size = rect.size
		
	

func presentation_mode():
	_mode = MODES.PRESENTATION
	emit_signal("presentation_mode")
	# warning-ignore:return_value_discarded
	get_tree().create_timer(0.1).connect("timeout", self, "snapshot")
	

	var dialog = get_node(dialog_path)
	var name = get_node(name_path)
	var portrait = get_node(portrait_path)
	
	# Save Rects
	dialog_rect = dialog.get_global_rect()
	name_rect = name.get_global_rect()
	portrait_rect = portrait.get_global_rect()
	
	Preferences.add_rect(dialog_path, dialog_rect)
	Preferences.add_rect(name_path, name_rect)
	Preferences.add_rect(portrait_path, portrait_rect)
	
	# Save Text Content
	Preferences.add_text(dialog_path, dialog.text)
	Preferences.add_text(name_path, name.text)
	
	Preferences.save_to_disk(_preferences_location)
	
func edit_mode():
	_mode = MODES.EDIT
	emit_signal("edit_mode")

func init_save():
	Preferences.clear_save(_preferences_location)
	
	Preferences.add_font("root", "")
	Preferences.add_font_size("root", 16)
		
	Preferences.add_image($BackgroundLayer/Background.get_path(), "")
	Preferences.add_image($PortraitLayer/Portrait.get_path(), "")
	Preferences.add_image($DialogLayer/DialogBox/TextureRect.get_path(), "")
		
	Preferences.add_text($DialogLayer/DialogBox/DialogContent.get_path(), "")
	Preferences.add_text($DialogLayer/DialogBox/LineEdit.get_path(), "")
		
	Preferences.set_flag("wizard", true)
	
	Preferences.add_rect(dialog_path, dialog_rect)
	Preferences.add_rect(name_path, name_rect)
	Preferences.add_rect(portrait_path, portrait_rect)
		
	Preferences.save_to_disk(_preferences_location)

func setup_mode():
	_mode = MODES.SETUP
	emit_signal("setup_mode")

func snapshot():
	var img = get_viewport().get_texture().get_data()
	img.flip_y()
	img.save_png(_exports_location + _image_name + ".png")
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
	
	var filename = path.get_file()
	
	var image_dir = Directory.new()
	if (image_dir.open(_images_location) == OK):
		var file_path = _images_location + filename 
		image_dir.copy(path, file_path)
		var img_node = get_node(_image)
		
		Preferences.clear_image(img_node.get_path())
		Preferences.add_image(img_node.get_path(), file_path)
		Preferences.save_to_disk(_preferences_location)
	
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
	get_node(_image).change_texture(texture)
	
	$Super/ImageDialog.hide()
	
func _on_image_change(identifier: String):
	change_image(identifier)

func change_font():
	$Super/FontDialog.show()

func change_font_size(new_size: int):
	emit_signal("font_size_change", new_size)
	Preferences.add_font_size("root", new_size)
	Preferences.save_to_disk(_preferences_location)

func _on_font_selected(path):
	emit_signal("font_change", path)
	$Super/FontDialog.hide()
	
	var filename = path.get_file()
	var font_dir = Directory.new()
	if (font_dir.open(_preferences_location) == OK):
		var file_path = _preferences_location + filename 
		font_dir.copy(path, file_path)
	
		Preferences.clear_font("root")
		Preferences.add_font("root", path)
		Preferences.save_to_disk(_preferences_location)

func _on_FontChange_button_up():
	change_font()

func _on_FileName_text_changed(new_text):
	_image_name = new_text

func _on_FontSize_font_size_changed(size):
	change_font_size(size)
