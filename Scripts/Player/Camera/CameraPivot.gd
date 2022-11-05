extends Spatial

var camRot_h = 0
var camRot_v = 0
var invert_v = true
var invert_h = false
var cam_v_min = -55
var cam_v_max = 75
var h_acceleration = 10
var v_acceleration = 10
var mouse_sensitivity = 0.1
var camera_follow_acceleration = 5
var player

var h
var v

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var camera = $h/v/Camera
	camera.player = player
	camera.add_exception(player)
	h = $h
	v = $h/v

func set_player(player_node):
	player = player_node
	$h/v/Camera.add_exception(player)

func _input(event):
	if event is InputEventMouseMotion:
		var dir = 1 if invert_h else -1
		camRot_h += dir * event.relative.x * mouse_sensitivity
		dir = -1 if invert_v else 1
		var v_rotation = clamp(event.relative.y, -30, 30)
		camRot_v += dir * v_rotation * mouse_sensitivity

func _physics_process(delta):
	camRot_v = clamp(camRot_v, cam_v_min, cam_v_max)
	
	h.rotation_degrees.y = lerp(h.rotation_degrees.y, camRot_h, delta * h_acceleration)
	v.rotation_degrees.x = lerp(v.rotation_degrees.x, camRot_v, delta * v_acceleration)
	
	global_transform.origin = global_transform.origin.linear_interpolate(player.global_transform.origin, delta * camera_follow_acceleration) 
