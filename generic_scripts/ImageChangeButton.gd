extends Button
signal image_change

export var identifier: String
export var target: NodePath = ""
var _scale_target

export var inset:bool

func _ready():
	# warning-ignore:return_value_discarded
	connect("button_up", self, "_on_press")
	add_to_group("image_changer")
	_scale_target = get_node(target)
	
func _on_press():
	emit_signal("image_change", identifier)

func _process(delta):
	# Self Positioning
	var multiplier = 0.95
	
	if (inset):
		multiplier = 0.85
	
	rect_global_position.x = _scale_target.rect_global_position.x + (_scale_target.rect_size.x * multiplier)
	rect_global_position.y = _scale_target.rect_global_position.y
