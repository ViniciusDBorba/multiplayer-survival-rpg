extends Label

export(String) var text_id = "default"
var texts_handler

func _start():
	texts_handler = get_node("/root/TextHandler")
	text = texts_handler.get_text(text_id)

func _process(delta):
	var new_text = texts_handler.get_text(text_id)
	if text != new_text:
		text = new_text
