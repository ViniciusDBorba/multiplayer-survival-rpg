extends OnGround

export(float) var max_walk_speed = 8
export(float) var max_aiming_speed = 2

func enter():
	speed = 0.0
	velocity = Vector3()
	
func update(_delta):
	handle_movement(_delta)

func handle_movement(delta):
	var direction = Vector3.ZERO
	var input_directions = get_input_directions()
	
	if (input_directions.right):
		direction += owner.cam_h.transform.basis.x
	if (input_directions.left):
		direction += -owner.cam_h.transform.basis.x
	if (input_directions.back):
		direction += owner.cam_h.transform.basis.z
	if (input_directions.forward):
		direction += -owner.cam_h.transform.basis.z
	
	speed = max_walk_speed
	if owner.is_aiming:
		speed = max_aiming_speed

	velocity.x = lerp(velocity.x, direction.x * speed, delta * 10)
	velocity.z = lerp(velocity.z, direction.z * speed, delta * 10)
	velocity.y -= fall_acceleration * delta
	velocity = owner.move_and_slide(velocity, Vector3.UP)
		
	var look_at_direction = owner.translation + direction
	if owner.transform.origin != look_at_direction:
		owner.look_at(look_at_direction, Vector3.UP)
	rpc_unreliable("apply_transform", owner.transform)
	if owner.is_aiming:
		owner.look_at(-owner.cam_h.transform.basis.z * 1000, Vector3.UP)
		rpc_unreliable("apply_transform", owner.transform)

puppet func apply_transform(transform):
	owner.transform.origin = transform.origin
	owner.transform.basis = transform.basis
