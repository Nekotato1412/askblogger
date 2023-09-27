extends OptionButton

var _chosen_width = 640
var _chosen_height = 480

func renderCustomRes(index):
	if (index == 2):
		$Resolution.show()
	else:
		$Resolution.hide()

func _on_Presets_item_selected(index):
	renderCustomRes(index)
	
	# VXA Preset: 640x480
	if (index == 0):
		_chosen_width = 640
		_chosen_height = 480

	# MGQ Preset: 800x600
	if (index == 1):
		_chosen_width = 800
		_chosen_height = 600


func _on_Res_X_text_changed(new_text):
	_chosen_width = int(new_text)

func _on_Res_Y_text_changed(new_text):
	_chosen_height = int(new_text)

func get_chosen_size() -> Vector2:
	return Vector2(_chosen_width, _chosen_height)
