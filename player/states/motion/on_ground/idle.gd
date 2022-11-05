extends OnGround

func update(_delta):
	if is_moving():
		emit_signal("finished", "move")
	
