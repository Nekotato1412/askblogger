extends Control

var can_drag = true
var _is_hovering = false
var _is_dragging = false
onready var screen_size = get_viewport_rect().size

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
		rect_global_position += current_mouse_pos - last_mouse_pos
		
		rect_global_position.x = clamp(rect_global_position.x, 0, screen_size.x - rect_size.x)
		rect_global_position.y = clamp(rect_global_position.y, 0, screen_size.y - rect_size.y)
		
	last_mouse_pos = current_mouse_pos


func _on_PortraitBox_mouse_entered():
	_is_hovering = true
	print("Entered!")


func _on_PortraitBox_mouse_exited():
	_is_hovering = false
