extends Position3D

var aim_position

func _physics_process(_delta):
	if not is_network_master():
		return
	if owner.is_aiming:
		look_at(aim_position.global_transform.origin, Vector3.UP)
		rpc_unreliable("apply_weapon_transform", transform)

puppet func apply_weapon_transform(newTransform):
	transform.basis = newTransform.basis
