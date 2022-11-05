extends Handler

class_name ItemHandler

var close_items = []
onready var action_timer = Timer.new()

func initialize(handler_machine):
	.initialize(handler_machine)
	var err = action_timer.connect("timeout", self, "action_timeout")
	if err:
		printerr(err)
	add_child(action_timer)

func add_close_item(item_node):
	if not is_network_master():
		return
	close_items.append(item_node)
	update_highlighted_item()

func remove_close_item(item_node):
	if not is_network_master():
		return
	item_node.toggle_higlight()
	close_items.remove(close_items.find(item_node))
	update_highlighted_item()

func update_highlighted_item():
	if not is_network_master():
		return

	if close_items.size() == 0: 
		get_tree().call_group("player_ui", "hide_item_actions_text")
	else:
		var item = close_items[0]
		item.toggle_higlight()
		get_tree().call_group("player_ui", "show_item_actions_text", item)

func _on_Player_start_acting():
	action_timer.start(0.5)

func _on_Player_stop_acting():
	if !action_timer.is_stopped():
		action_timer.stop()
		if close_items.size() >= 1:
			rpc_unreliable("collect_item", close_items[0].get_path())

func action_timeout():
	if close_items.size() == 0:
		return
	var item_node = close_items[0]
	if item_node != null:
		rpc_unreliable("do_item_action", item_node.get_path())
	action_timer.stop()

func load_item_resource(item_node):
	if get_tree().get_network_unique_id() == 1:
		return
	return load("res://Resources/Items/"+ ItemResource.item_type_name(item_node.item_type) +"/Infos/"+item_node.item_id+".tres")
