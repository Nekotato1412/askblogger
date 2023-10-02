extends Control

var can_drag = false
var _is_hovering = false
var _is_dragging = false

export var target: NodePath = ""
var _scale_target

enum Modes {
	X,
	Y
}

var last_target_pos:Vector2

func _ready():
	_scale_target = get_node(target)
	last_target_pos = _scale_target.rect_global_position
	hide()

	

export (Modes) var edge_mode = Modes.X

func _on_Main_presentation_mode():
	can_drag = false
	hide()

func _on_Main_setup_mode():
	can_drag = true
	show()

func _on_Main_edit_mode():
	can_drag = false
	hide()

func _on_Scale_Widget_mouse_entered():
	_is_hovering = true

func _on_Scale_Widget_mouse_exited():
	_is_hovering = false

onready var last_mouse_pos = get_global_mouse_position()
func _process(delta):

	
	if edge_mode == Modes.X:
		rect_global_position.x = _scale_target.rect_global_position.x - (rect_size.x * 1.25)
		rect_global_position.y = _scale_target.rect_global_position.y + _scale_target.rect_size.y / 2
	elif edge_mode == Modes.Y:
		rect_global_position.x = _scale_target.rect_global_position.x + _scale_target.rect_size.x / 2
		rect_global_position.y = _scale_target.rect_global_position.y - (rect_size.y * 1.1)
	
	
	if not can_drag: return
	var current_mouse_pos = get_global_mouse_position()
	
	if _is_hovering and Input.is_action_pressed("drag"):
		_is_dragging = true
	else:
		_is_dragging = false
		
	if _is_dragging:
		if edge_mode == Modes.X:
			_scale_target.rect_size.x -= current_mouse_pos.x - last_mouse_pos.x
			_scale_target.rect_global_position.x += current_mouse_pos.x - last_mouse_pos.x
		elif edge_mode == Modes.Y:
			_scale_target.rect_size.y -= current_mouse_pos.y - last_mouse_pos.y
			_scale_target.rect_global_position.y += current_mouse_pos.y - last_mouse_pos.y
		
	last_mouse_pos = current_mouse_pos
