extends KinematicBody

#signals
signal start_acting
signal stop_acting

#Logic references
var cam_h
var camera_reference

#In game values
var is_aiming
onready var state_machine = $StateMachine
onready var handler_controller = $HandlerController

func _ready():
	add_to_group("Player", true)
	
func initialize():
	cam_h = preload("res://player/PlayerCamera.tscn").instance()
	cam_h.player = self
	cam_h.set_network_master(get_tree().get_network_unique_id(), true)
	get_parent().add_child(cam_h)
	cam_h = cam_h.get_node("h")
	camera_reference = cam_h.get_node("v/Camera")
	camera_reference.player = self
	handler_controller.initialize()

remotesync func hit_player(shoot_name, mark_position, damage):
	var bulletPoint = preload("res://Nodes/Items/BulletPoint.tscn").instance()
	bulletPoint.set_name(shoot_name)
	add_child(bulletPoint)
	bulletPoint.global_transform.origin = mark_position
	if is_network_master():
		handler_controller.remove_health(damage)
	
func add_health(health_quantity):
	handler_controller.add_health(health_quantity)

#Inputs 
func _input(event):
	if not is_network_master() or get_tree().get_network_unique_id() == 1:
		return
	if event.is_action_pressed("aim"):
		is_aiming = true
	if event.is_action_released("aim"):
		is_aiming = false
	
	handle_action_inputs()

func handle_action_inputs():
	if Input.is_action_just_pressed("action"):
		emit_signal("start_acting")
	if Input.is_action_just_released("action"):
		emit_signal("stop_acting")

#Items
func add_close_item(item_node):
	if is_network_master():
		handler_controller.add_close_item(item_node)

func remove_close_item(item_node):
	if is_network_master():
		handler_controller.remove_close_item(item_node)

func die():
	state_machine._change_state("die")

func player_spawned(faction):
	if is_network_master():
		var spawn_position = get_node("/root/TestScene/SpawnPoint " + str(Factions.get_faction_value(faction))).transform.origin
		rpc("set_position", spawn_position)

remotesync func set_position(position):
	transform.origin = position
