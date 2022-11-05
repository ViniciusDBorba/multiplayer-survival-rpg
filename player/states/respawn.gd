extends State

func enter():
	rpc("start_respawn_count", owner.get_path())

remotesync func start_respawn_count(who_node_path):
	var who = get_node(who_node_path)
	respawn(who)
	

func respawn(who):
	who.get_node("CollisionShape").disabled = false
	who.set_process_input(true)
	who.set_physics_process(true)
	who.add_health(100)
	if is_network_master():
		who.cam_h.get_node("../").set_player(who)
		who.player_spawned(MultiplayerHandler.myInfo.faction)
	who.show()
	emit_signal("finished", "idle")
