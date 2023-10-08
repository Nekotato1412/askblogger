extends Resource
class_name SaveData

# Expected format: Name: True or False
export var flags:Dictionary = {}

# Expected format: NodePath: user://FilePath
export var image_paths:Dictionary = {}

# Expected format: NodePath: Text
export var text_content:Dictionary = {}

# Exported format: Name: Size
export var font_sizes:Dictionary = {}

# Exported format: Name: user://FilePath
export var font_paths:Dictionary = {}

export var save_name: String = "save"

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
	
	self.flags = save_file.flags
	self.image_paths = save_file.image_paths
	self.text_content = save_file.text_content
	self.save_name = save_file.save_name
	self.font_sizes = save_file.font_sizes
	self.font_paths = save_file.font_paths
	
	return OK

func save_to_disk(location: String):
	var error = ResourceSaver.save(location + self.save_name + ".tres", self)
	return error
	
func add_image(node: NodePath, file_path: String):
	self.image_paths[node] = file_path

func clear_image(node:NodePath):
	if (!self.image_paths.has(node)): return
	var path = self.image_paths[node];
	var image_folder = path.get_base_dir()
	
	
	var old_image = Directory.new()
	if (old_image.open(image_folder) == OK):
		old_image.remove(path)


func add_text(node: NodePath, text: String):
	self.text_content[node] = text

func add_font(name: String, path: String):
	self.font_paths[name] = path

func add_font_size(name: String, size: int):
	font_sizes[name] = size

func set_flag(name: String, value: bool):
	self.flags[name] = value

func get_flag(name: String):
	return self.flags.get(name)




func is_class(compare: String) -> bool:
	return compare == "SaveData"
func get_class() -> String:
	return "SaveData"
