extends Handler

#Logic variables
var holster_weapon
var equiped_weapon
var equiped_weapon_resource
var is_atacking
var shoot_index
onready var weapons_resources_path = "res://Resources/Items/weapons/"

#Script references
onready var point = preload("res://Nodes/Items/BulletPoint.tscn")
onready var weapon_slot = get_node("../../WeaponSlot")
onready var holster_slot = get_node("../../HolsterSlot")
var ray_position
var ray

func initialize(handler_machine):
	.initialize(handler_machine)
	holster_weapon = null
	shoot_index = 0
	ray_position = owner.cam_h.get_node("v/RaycastPosition")
	ray = owner.camera_reference.get_node("RayCast")
	ray.set_enabled(true)
	weapon_slot.aim_position = ray_position
	equiped_weapon = null

func _input(_event):
	if !is_network_master():
		return

	if Input.is_action_just_pressed("attack"):
		is_atacking = true
	if Input.is_action_just_released("attack"):
		is_atacking = false
	if Input.is_action_just_pressed("holster_weapon"):
		handle_holster_weapon()
		rpc("handle_holster_weapon")

func equip_weapon(weapon, caller_id = get_tree().get_network_unique_id()):
	if equiped_weapon != null:
		return
	weapon.get_parent().remove_child(weapon)
	weapon_slot.add_child(weapon)
	reset_node_position_rotation(weapon)
	equiped_weapon = weapon
	equiped_weapon_resource = get_parent().inventory_handler.load_item_resource(equiped_weapon)

puppet func handle_holster_weapon():
	if !has_equiped_weapon() and has_holster_weapon():
		equip_weapon(holster_weapon)
		holster_weapon = null
		return
	if has_equiped_weapon() and !has_holster_weapon():
		equiped_weapon.get_parent().remove_child(equiped_weapon)
		holster_slot.add_child(equiped_weapon)
		reset_node_position_rotation(equiped_weapon)
		holster_weapon = equiped_weapon
		equiped_weapon = null
		equiped_weapon_resource = null
		return

func has_holster_weapon():
	return holster_weapon != null

func has_equiped_weapon():
	return equiped_weapon != null
	
func reset_node_position_rotation(node):
	node.transform.origin = Vector3(0, 0, 0)
	node.transform.basis = Basis(Vector3(0, 0, 0))

remotesync func instantiate_mark(shoot_name, position):
	var bulletPoint = point.instance()
	bulletPoint.set_name(shoot_name)
	get_node("/root/TestScene").add_child(bulletPoint)
	bulletPoint.global_transform.origin = position

func handle_shoot_collision(collidedNode, mark_position):
	var shoot_name = String(get_name()) + str(shoot_index)
	
	if collidedNode.is_in_group("player"):
		collidedNode.rpc("hit_player", shoot_name, mark_position, equiped_weapon_resource.damage)
	else:
		rpc("instantiate_mark", shoot_name, mark_position)
	if collidedNode.is_in_group("Enemy"):
		collidedNode.apply_damage(equiped_weapon_resource.damage)

func _process(_delta):
	if not is_network_master():
		return
	if owner.is_aiming and is_atacking:
		shoot()
		is_atacking = false

func shoot():
	if equiped_weapon == null:
		return
	shoot_index += 1
	var aim_position = equiped_weapon.get_shoot_position()
	aim_position.z = -1000
	ray.set_cast_to(ray_position.transform.origin)
	var collidedNode = ray.get_collider()
	if (collidedNode != null):
		handle_shoot_collision(collidedNode, ray.get_collision_point())
