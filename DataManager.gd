extends Node
signal save_success
signal data_loaded
signal error_thrown

# Deferred to Main
signal font_change
signal font_size_change
signal set_outline
signal update_preference

var _preferences_location = "user://data/"
var _images_location = "user://data/images/"
var _exports_location = "user://exports/"

var _saving = false

onready var Preferences = SaveData.new()

export var background_path: NodePath = ""
export var dialog_path: NodePath = ""
export var name_path:NodePath = ""
export var portrait_path:NodePath = ""
export var dialog_texture_path: NodePath = ""

var portrait_rect: Rect2
var dialog_rect: Rect2
var name_rect: Rect2
var dialog_texture_rect: Rect2

var _temp_forced_pos: Vector2

func _on_save():
	if (not _saving):
		_saving = true
		get_tree().create_timer(0.10).connect("timeout", self, "_save_preferences")

func _ready():
	assert(background_path != "" or background_path != null, "background_path must be defined.")
	assert(dialog_path != "" or dialog_path != null, "dialog_path must be defined.")
	assert(name_path != "" or name_path != null, "name_path must be defined.")
	assert(portrait_path != "" or portrait_path != null, "portrait_path must be defined.")
	assert(dialog_texture_path != "" or dialog_texture_path != null, "dialogue_texture_path must be defined.")
	
	dialog_rect = get_node(dialog_path).get_global_rect()
	name_rect = get_node(name_path).get_global_rect()
	portrait_rect = get_node(portrait_path).get_global_rect()
	dialog_texture_rect = get_node(dialog_texture_path).get_global_rect()
	
	get_tree().get_root().connect("size_changed", self, "_on_resize")
	Preferences.set_save_name("preferences")
	_init_directories()
	_load_resources()
	emit_signal("data_loaded")

func get_data() -> SaveData:
	return Preferences

func get_exports_location() -> String:
	return _exports_location

func _load_resources():
	var error = Preferences.load_from_disk(_preferences_location)
	
	if (error == ERR_FILE_UNRECOGNIZED):
		emit_signal("error_thrown", "Preferences data could not be loaded. The file could not be recognized.")
		_init_save()
	
	if (error == ERR_FILE_NOT_FOUND):
		_init_save()
	
	if (error == OK):
		# Screen Size
		var screen_size = Preferences.get_size("viewport")
		if screen_size != null:
			OS.window_size = screen_size
			OS.center_window()
		
		# Textures
		for node_path in Preferences.image_paths.keys():
			var image_node = get_node(node_path)
			var texture = Preferences.get_image(node_path)
			
			if texture == null: continue
			
			image_node.change_texture(texture)
			
		
		# Font Info
		var font = Preferences.get_font_path("root")
		var font_size = Preferences.get_font_size("root")
		var outline = Preferences.get_flag("fontoutline")
		
		if (outline != null):
			emit_signal("set_outline", int(outline))
		
		var autoopen = Preferences.get_flag("autoopen")
		if (autoopen != null):
			emit_signal("update_preference", "autoopen", autoopen)
		
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
			rect_node.rect_size = rect.size
			rect_node.set("rect_global_position", rect.position)

func _init_save():
	Preferences.clear_save(_preferences_location)
	
	Preferences.add_font("root", "")
	Preferences.add_font_size("root", 16)
		
	Preferences.add_image(background_path, "")
	Preferences.add_image(portrait_path, "")
	Preferences.add_image(dialog_texture_path, "")
		
	Preferences.add_text(dialog_path, "")
	Preferences.add_text(name_path, "")
	
	Preferences.set_flag("autoopen", true)
	Preferences.set_flag("fontoutline", true)
	
	Preferences.add_rect(dialog_path, dialog_rect)
	Preferences.add_rect(name_path, name_rect)
	Preferences.add_rect(portrait_path, portrait_rect)
	Preferences.add_rect(dialog_texture_path, dialog_texture_rect)
	
	Preferences.add_size("viewport", get_viewport().size)
		
	Preferences.save_to_disk(_preferences_location)

func _init_directories():
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

func _save_preferences():
	update_rects()
	save_rects()
	save_text_content()
	
	var error = Preferences.save_to_disk(_preferences_location)
	if (error == OK):
		_saving = false
	else:
		printerr("[I/O Error: " + str(error))
		get_tree().quit(error)

func update_font(path: String):
	var filename = path.get_file()
	var font_dir = Directory.new()
	if (font_dir.open(_preferences_location) == OK):
		var file_path = _preferences_location + filename 
		font_dir.copy(path, file_path)
		
		# Save Font
		Preferences.clear_font("root")
		Preferences.add_font("root", file_path)

		return file_path
	else:
		printerr("[I/O]: Cannot open preferences location.")
		get_tree().quit(ERR_CANT_OPEN)

func update_font_size(size: int):
	Preferences.add_font_size("root", size)

func update_image(path: String, image_node: Node):
	var image = Image.new()
	var err = image.load(path)
	if (err != OK):
		return err

	var filename = path.get_file()
	
	var image_dir = Directory.new()
	if (image_dir.open(_images_location) == OK):
		var file_path = _images_location + filename 
		image_dir.copy(path, file_path)
		
		Preferences.clear_image(image_node.get_path())
		Preferences.add_image(image_node.get_path(), file_path)
	
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	return texture

func update_flag(name: String, value: bool):
	Preferences.set_flag(name, value)

func update_rects():
	dialog_rect = get_node(dialog_path).get_global_rect()
	name_rect = get_node(name_path).get_global_rect()
	portrait_rect = get_node(portrait_path).get_global_rect()
	dialog_texture_rect = get_node(dialog_texture_path).get_global_rect()

func save_rects():
	Preferences.add_rect(dialog_path, dialog_rect)
	Preferences.add_rect(name_path, name_rect)
	Preferences.add_rect(portrait_path, portrait_rect)
	Preferences.add_rect(dialog_texture_path, dialog_texture_rect)

func save_text_content():
	var dialog = get_node(dialog_path)
	var name = get_node(name_path)
	
	Preferences.add_text(dialog_path, dialog.text)
	Preferences.add_text(name_path, name.text)

func _on_resize():
	Preferences.add_size("viewport", get_viewport().size)
