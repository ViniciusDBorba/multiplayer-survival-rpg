extends PanelContainer

var text_id

var text_handler

#Ui components
var pickup_label
var hold_label
var hold_action_label
var hold_container


func _ready():
	pickup_label = $"VBoxContainer/GetContainer/PickupLabel"
	hold_container = $"VBoxContainer/HoldActContainer"
	hold_label = $"VBoxContainer/HoldActContainer/HoldLabel"
	hold_action_label = $"VBoxContainer/HoldActContainer/ActionLabel"
	text_handler = $"/root/TextHandler"
	update_action_key_label()
	text_handler.connect("language_file_updated", self, "update_text")
	#var inventory = $"../../../../../../Player/InventoryHandler"
	#inventory.connect("update_pickup_ui", self, "update_labels")
	#inventory.connect("set_pickup_ui_position", self, "set_ui_position")

func update_hold_action_label(item_type):
	var visible = false
	match item_type:
		ItemResource.item_types.HEALTH:
			hold_action_label.text = text_handler.get_text("use")
			visible = true
		ItemResource.item_types.WEAPON:
			hold_action_label.text = text_handler.get_text("equip")
			visible = true
	hold_container.visible = visible

func update_action_key_label():
	var action = InputMap.get_action_list("action")[0]
	$VBoxContainer/GetContainer/Panel/Label.text = OS.get_scancode_string(action.scancode)
	
func update_hold_label():
	hold_label.text = text_handler.get_text("hold")

func update_text():
	set_pickup_text(text_id)

func set_pickup_text(item_id):
	self.text_id = item_id
	pickup_label.text = text_handler.get_text(text_id)

func set_ui_position(position):
	set_position(position)

func update_labels(item_id, item_type):
	set_pickup_text(item_id)
	update_hold_action_label(item_type)
