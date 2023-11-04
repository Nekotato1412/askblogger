extends Resource
class_name SaveData

export var save_name: String

# Expected format: Name: True or False
export var flags:Dictionary = {}

# Expected format: NodePath: user://FilePath
export var image_paths:Dictionary = {}

# Expected format: NodePath: Text
export var text_content:Dictionary = {}

# Expected format: Name: Size
export var font_sizes:Dictionary = {}

# Expected format: Name: user://FilePath
export var font_paths:Dictionary = {}

# Expected format: Node: [Rect2]
export var rects:Dictionary = {}

# Expected format: Identifier: [Vector2]
export var sizes:Dictionary = {}

func set_save_name(new_name: String):
	self.save_name = new_name

func load_from_disk(location: String):
	var save_file = load(location + self.save_name + ".tres")
	
	if (save_file == null):
		return ERR_FILE_NOT_FOUND
		
	
	if (save_file.get("image_paths") == null):
		return ERR_FILE_UNRECOGNIZED
	if (save_file.get("text_content") == null):
		return ERR_FILE_UNRECOGNIZED
	if (save_file.get("flags") == null):
		return ERR_FILE_UNRECOGNIZED
	if (save_file.get("save_name") == null):
		return ERR_FILE_UNRECOGNIZED
	if (save_file.get("font_sizes") == null):
		return ERR_FILE_UNRECOGNIZED
	if (save_file.get("font_paths") == null):
		return ERR_FILE_UNRECOGNIZED
	
	if (save_file.get("rects") == null):
		return ERR_FILE_UNRECOGNIZED
	
	if (save_file.get("sizes") == null):
		return ERR_FILE_UNRECOGNIZED
	
	self.flags = save_file.flags
	self.image_paths = save_file.image_paths
	self.text_content = save_file.text_content
	self.save_name = save_file.save_name
	self.font_sizes = save_file.font_sizes
	self.font_paths = save_file.font_paths
	self.rects = save_file.rects
	self.sizes = save_file.sizes
	
	return OK

func save_to_disk(location: String):
	var error = ResourceSaver.save(location + self.save_name + ".tres", self)
	return error

func clear_save(location: String):
	var file_path = location + self.save_name + ".tres"
	
	var save_folder = Directory.new()
	if (save_folder.open(location) == OK):
		save_folder.remove(file_path)
	
func add_image(node: NodePath, file_path: String):
	self.image_paths[node] = file_path

func clear_image(node:NodePath):
	if (!self.image_paths.has(node)): return
	var path = self.image_paths[node];
	var image_folder = path.get_base_dir()
	
	
	var old_image = Directory.new()
	if (old_image.open(image_folder) == OK):
		old_image.remove(path)

func get_image(node: NodePath) -> ImageTexture:
	if (!self.image_paths.has(node)): return null
	if (self.image_paths[node] == ""): return null
	
	var path = ProjectSettings.globalize_path(self.image_paths[node])
	
	var image = Image.new()

	if (image.load(path) == OK):
		var texture = ImageTexture.new()
		texture.create_from_image(image)
		return texture
	
	return null

func add_text(node: NodePath, text: String):
	self.text_content[node] = text

func get_text(node: NodePath):
	return self.text_content.get(node)

func add_font(name: String, path: String):
	self.font_paths[name] = path

func clear_font(name: String):
	if (!self.font_paths.has(name)): return
	var path = self.font_paths[name];
	var font_folder = path.get_base_dir()
	
	
	var old_font = Directory.new()
	if (old_font.open(font_folder) == OK):
		old_font.remove(path)

func get_font_path(name: String) -> String:
	return self.font_paths.get(name)

func add_font_size(name: String, size: int):
	self.font_sizes[name] = size

func get_font_size(name: String) -> int:
	return self.font_sizes.get(name)

func set_flag(name: String, value: bool):
	self.flags[name] = value

func get_flag(name: String) -> bool:
	return self.flags.get(name)

func add_rect(node: NodePath, rect: Rect2):
	self.rects[node] = rect

func get_rect(node: NodePath) -> Rect2:
	return self.rects.get(node)

func add_size(identifier: String, size: Vector2):
	self.sizes[identifier] = size

func get_size(identifier: String) -> Rect2:
	return self.sizes.get(identifier)

func is_class(compare: String) -> bool:
	return compare == "SaveData"
func get_class() -> String:
	return "SaveData"
