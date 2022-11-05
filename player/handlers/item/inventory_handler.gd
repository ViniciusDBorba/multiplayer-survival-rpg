extends ItemHandler

#Script variables
var stored_items = []

#Script references
onready var inventory_item = preload("res://Scripts/Items/Resource/inventory_item.gd")

#Initialize
func initialize(handler_controller):
	.initialize(handler_controller)
	$PocketsHandler.initialize(handler_controller)

remotesync func item_used(item_node_path):
	var item_node = get_node(item_node_path)
	item_node.queue_free()

remotesync func do_item_action(item_node_path):
	var item_node = get_node(item_node_path)
	if item_node.item_type == ItemResource.item_types.WEAPON:
		get_parent().equip_weapon(item_node)
	else:
		if use_item(load_item_resource(item_node)):
			rpc("item_used", item_node.get_path())

func use_item(item_resource):
	if owner.name != str(get_tree().get_network_unique_id()):
		return
	var used = false
	match item_resource.type:
		ItemResource.item_types.HEALTH:
			if get_parent().need_health():
				item_resource.use(owner)
				used = true
	return used

remotesync func collect_item(item_node_path):
	var item_node = get_node(item_node_path)
	if item_node.item_type == ItemResource.item_types.HEALTH:
		$PocketsHandler.store_item(item_node)

func delete_item(store_item_position):
	stored_items.remove(store_item_position)
