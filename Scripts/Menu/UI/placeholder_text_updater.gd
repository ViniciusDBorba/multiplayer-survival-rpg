extends LineEdit

export(String) var text_id = "default"
var texts_handler

func _ready():
	texts_handler = get_node("/root/TextHandler")
	placeholder_text = texts_handler.get_text(text_id)

func _process(delta):
	var new_text = texts_handler.get_text(text_id)
	if placeholder_text != new_text:
		placeholder_text = new_text
