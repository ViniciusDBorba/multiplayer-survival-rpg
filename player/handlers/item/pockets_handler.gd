extends Handler

#Instances
onready var inventory = get_parent()

#Pockets mechanic variables
var pockets = {"left":{}, "right":{}, "back_left":{}, "back_right":{}}

func initialize(handler_machine):
	.initialize(handler_machine)
	for pocket_key in pockets.keys():
		prepare_pocket(pocket_key)

func prepare_pocket(pocket_key):
	pockets[pocket_key] = get_parent().inventory_item.new()
	var action = InputMap.get_action_list("pocket_"+pocket_key)[0]
	get_tree().call_group("player_ui", "set_pocket_action_key", pocket_key, OS.get_scancode_string(action.scancode))

func get_pocket_key(pocket):
	var pockets_keys = pockets.keys()
	var pocket_key_position = pockets.values().find(pocket)
	return pockets_keys[pocket_key_position]

func _input(_event):
	if !is_network_master():
		return

	if Input.is_action_just_pressed("pocket_left"):
		use_pocket_item(pockets.left)
	if Input.is_action_just_pressed("pocket_right"):
		use_pocket_item(pockets.right)
	if Input.is_action_just_pressed("pocket_back_left"):
		use_pocket_item(pockets.back_left)
	if Input.is_action_just_pressed("pocket_back_right"):
		use_pocket_item(pockets.back_right)

func store_item(item_node):
	var item = inventory.load_item_resource(item_node)
	item_node.queue_free()

	if owner.name != str(get_tree().get_network_unique_id()):
		return

	var pocket = find_pocket_to(item)
	if pocket == null:
		return
	
	pocket.has_item = true
	pocket.item_id = item.item_id
	pocket.item_type = item.type
	pocket.quantity += 1
	if pocket.quantity == 1:
		inventory.stored_items.append(item)
	pocket.store_position = inventory.stored_items.find(item)
	
	get_tree().call_group("player_ui", "update_pocket_ui", get_pocket_key(pocket), pocket)

func find_pocket_to(item):
	for pocket in pockets.values():
		if !pocket.has_item:
			return pocket
		if pocket.item_id == item.item_id and pocket.quantity < item.item_max_stack:
			return pocket

func use_pocket_item(pocket):
	if not is_network_master():
		return

	if !pocket.has_item:
		return

	var item = inventory.stored_items[pocket.store_position]
	var used = get_parent().use_item(item)
	if not used:
		return
	pocket.quantity -= 1
	
	if pocket.quantity >= 1:
		get_tree().call_group("player_ui", "update_pocket_ui", get_pocket_key(pocket), pocket)
	else:
		delete_pocket_item(pocket)
		get_tree().call_group("player_ui", "hide_pocket_ui", get_pocket_key(pocket))

func delete_pocket_item(pocket):
	inventory.delete_item(pocket.store_position)
	pocket.quantity = 0
	pocket.has_item = false
	pocket.store_position = 0



