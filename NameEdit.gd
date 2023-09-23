extends LineEdit

var default_bg = StyleBoxEmpty.new()
var setup_bg = StyleBoxFlat.new()

onready var screen_size = get_viewport_rect().size

var can_drag = false
var _is_hovering = false
var _is_dragging = false

func _ready():
	setup_bg.bg_color = Color(255, 255, 255, 0.5)
	setup_bg.border_color = Color.cyan
	
	setup_bg.border_width_bottom = 2
	setup_bg.border_width_top = 2
	setup_bg.border_width_left = 2
	setup_bg.border_width_right = 2

func revert_stylebox():
	self.add_stylebox_override("normal", default_bg)

func setup_stylebox():
	self.add_stylebox_override("normal", setup_bg)

func disable_edit():
	focus_mode = FOCUS_NONE
	selecting_enabled = false
	shortcut_keys_enabled = false
	middle_mouse_paste_enabled = false

func enable_edit():
	focus_mode = FOCUS_ALL
	selecting_enabled = true
	shortcut_keys_enabled = true
	middle_mouse_paste_enabled = true
	

func _on_Main_presentation_mode():
	disable_edit()
	revert_stylebox()
	can_drag = false


func _on_Main_edit_mode():
	enable_edit()
	revert_stylebox()
	can_drag = false


func _on_Main_setup_mode():
	disable_edit()
	setup_stylebox()
	can_drag = true


func _on_LineEdit_mouse_entered():
	_is_hovering = true


func _on_LineEdit_mouse_exited():
	_is_hovering = false

onready var last_mouse_pos = get_global_mouse_position()

func _process(_delta):
	if not can_drag: return
	
	var current_mouse_pos = get_global_mouse_position()
	
	if _is_hovering and Input.is_action_pressed("drag"):
		_is_dragging = true
	else:
		_is_dragging = false
		
	if _is_dragging:
		rect_global_position += current_mouse_pos - last_mouse_pos
		
		rect_global_position.x = clamp(rect_global_position.x, 0, screen_size.x - rect_size.x)
		rect_global_position.y = clamp(rect_global_position.y, 0, screen_size.y - rect_size.y)
		
	last_mouse_pos = current_mouse_pos
		
		


func _on_Main_font_change(path):
	var font = get_font("font")
	var fontData = DynamicFontData.new()
	fontData.font_path = path
	font.font_data = fontData
	add_font_override("font", font)
