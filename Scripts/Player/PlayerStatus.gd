extends Spatial

enum status_enum {
	DEAD,
	MOVING
}

var actual_status = status_enum.MOVING

remote func set_actual_status(status):
	actual_status = status
	if get_tree().get_network_unique_id() == 1:
		get_node("/root/MultiplayerHandler").set_player_status(actual_status)

func is_dead():
	return actual_status == status_enum.DEAD

func moving():
	rpc("set_actual_status", status_enum.MOVING)

func dead():
	rpc("set_actual_status", status_enum.DEAD)


