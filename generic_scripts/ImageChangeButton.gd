extends Button
signal image_change

export var identifier: String


func _ready():
	# warning-ignore:return_value_discarded
	connect("button_up", self, "_on_press")
	add_to_group("image_changer")


func _on_press():
	emit_signal("image_change", identifier)
