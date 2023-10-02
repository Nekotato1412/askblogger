extends TextureRect

onready var screen_size = get_viewport_rect().size
onready var _old_screen_size = screen_size

var can_drag = false
var _is_hovering = false
var _is_dragging = false
var _drawing_border = false

func _on_Main_edit_mode():
	can_drag = false
	hide_border()


func _on_Main_presentation_mode():
	can_drag = false
	hide_border()


func _on_Main_setup_mode():
	can_drag = true
	draw_border()

func _on_Texture_mouse_entered():
	_is_hovering = true

func _on_Texture_mouse_exited():
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
		screen_size = get_viewport_rect().size
		if (screen_size != _old_screen_size):
			var old_difference = _old_screen_size - rect_size
			var new_difference = screen_size - rect_size
			rect_size = (rect_size + new_difference) - old_difference
			_old_screen_size = screen_size
			
		
		rect_global_position += current_mouse_pos - last_mouse_pos
		
		var bounds_x = rect_size.x + 75
		var bounds_y = rect_size.y + 25
		
		rect_global_position.x = clamp(rect_global_position.x, -bounds_x / 2, bounds_x * 2)
		rect_global_position.y = clamp(rect_global_position.y, -bounds_y / 2, bounds_y)
		
	last_mouse_pos = current_mouse_pos

func draw_border():
	_drawing_border = true
	update()

func hide_border():
	_drawing_border = false
	update()

func _draw():
	if _drawing_border:
		draw_rect(Rect2(Vector2(0, 0), rect_size), Color.white, false, 1.0)

func center():
	var new_x = (screen_size.x / 2) - (rect_size.x / 2)
	var new_y = (screen_size.y / 8) + (rect_size.y / 8)
	set_global_position(Vector2(new_x, new_y))

func enforce_size(dim):
	var new_size = dim
	new_size.x = clamp(new_size.x, 0, screen_size.x)
	new_size.y = clamp(new_size.y, 0, screen_size.y)
	self.set_size(new_size)

func change_texture(texture):
	self.texture = texture
	enforce_size(texture.get_size())
	center()
