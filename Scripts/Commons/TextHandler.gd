extends Node

export(Resource) var texts_file

signal language_file_updated

func _ready():
	change_texts_file("pt_br")

func change_texts_file(file_name):
	texts_file = load("res://Resources/language/"+ file_name + ".tres")
	emit_signal("language_file_updated")

func get_text(text_id):
	return texts_file.get(text_id)
