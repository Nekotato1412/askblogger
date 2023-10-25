extends Button

export var link = ""
var hover_format = "[u]%s[/u]"
onready var label = $RichTextLabel.bbcode_text

func _on_Watermark_button_up():
	OS.shell_open(link)

func _on_Watermark_mouse_entered():
	$RichTextLabel.bbcode_text = hover_format % label


func _on_Watermark_mouse_exited():
	$RichTextLabel.bbcode_text = label
