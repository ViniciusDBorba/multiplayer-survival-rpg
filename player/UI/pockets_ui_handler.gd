extends Control

onready var pockets_slots = $PocketsContainer/PocketsSlots

func set_pocket_action_key(pocket_key, action):
	$PocketsActionKeys.get_node(pocket_key).text = action

func update_pocket_ui(pocket_key, pocket):
	if not is_network_master():
		return
	var item_icon = pockets_slots.get_node(pocket_key + "/ItemIcon")
	if item_icon == null:
		return
	item_icon.texture = get_parent().load_item_image_texture(pocket.item_id, pocket.item_type)
	item_icon.get_node("ItemQuantity").text = str(pocket.quantity)
	item_icon.show()

func hide_pocket_ui(pocket_key):
	pockets_slots.get_node(pocket_key + "/ItemIcon").hide()
