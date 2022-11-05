extends Control

var health setget _set_health
onready var text_handler = $"/root/TextHandler"

func _ready():
	text_handler.connect("language_file_updated", self, "update_texts")

func update_texts():
	self.health = self.health

func show_item_actions_text(item):
	var action = InputMap.get_action_list("action")[0]
	var item_action
	match item.item_type:
		ItemResource.item_types.HEALTH:
			item_action = text_handler.get_text("use")
		ItemResource.item_types.WEAPON:
			item_action = text_handler.get_text("equip")
	var to_collect = text_handler.get_text("to_collect")
	var hold_for = text_handler.get_text("hold_for")
	$ItemText.text = '"' + OS.get_scancode_string(action.scancode) + '"' + to_collect + "." + hold_for + " " + item_action
	$ItemText.show()

func hide_item_actions_text():
	$ItemText.hide()

func update_health(new_health):
	if not is_network_master():
		return
	self.health = new_health
	
func _set_health(new_health):
	health = new_health
	$HealthLabel.text = text_handler.get_text("health") + ": " + str(self.health)
