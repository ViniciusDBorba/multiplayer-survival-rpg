extends State

func enter():
	rpc("set_dead", owner.get_path(), str(get_tree().get_rpc_sender_id()))

remotesync func set_dead(who_node_path, killer_id):
	var who = get_node(who_node_path)
	who.is_aiming = false
	who.get_node("CollisionShape").disabled = true
	who.hide()
	who.set_process_input(false)
	who.set_physics_process(false)
	if is_network_master():
		var killer = get_node("/root/TestScene/" + str(killer_id))
		who.cam_h.get_node("../").set_player(killer)
		emit_signal("finished", "respawn")
