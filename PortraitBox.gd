extends Control

onready var screen_size = get_viewport_rect().size

var can_drag = false
var _is_hovering = false
var _is_dragging = false

func modulate_setup():
	self.modulate = Color.blue

func modulate_revert():
	self.modulate = Color.white

func _on_Main_edit_mode():
	can_drag = false
	modulate_revert()


func _on_Main_presentation_mode():
	can_drag = false
	modulate_revert()


func _on_Main_setup_mode():
	can_drag = true
	modulate_setup()

func _on_PortraitBox_mouse_entered():
	_is_hovering = true

func _on_PortraitBox_mouse_exited():
	_is_hovering = false

onready var last_mouse_pos = get_global_mouse_position()
func _process(_delta):
	rect_size = $Texture.rect_size
	rect_size.x = clamp(rect_size.x, -screen_size.x, screen_size.x)
	rect_size.y = clamp(rect_size.y, -screen_size.y, screen_size.y)
	
	
	if not can_drag: return
	
	var current_mouse_pos = get_global_mouse_position()
	
	if _is_hovering and Input.is_action_pressed("drag"):
		_is_dragging = true
	else:
		_is_dragging = false
		
	if _is_dragging:
		screen_size = get_viewport_rect().size
		rect_global_position += current_mouse_pos - last_mouse_pos
		
		var bounds_x = rect_size.x + 75
		var bounds_y = rect_size.y + 25
		
		rect_global_position.x = clamp(rect_global_position.x, -bounds_x / 2, bounds_x * 2)
		rect_global_position.y = clamp(rect_global_position.y, -bounds_y / 2, bounds_y)
		
	last_mouse_pos = current_mouse_pos
