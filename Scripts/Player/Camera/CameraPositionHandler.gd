extends ClippedCamera

var defaultPosition
var aimPosition
var rayPosition
var ray
var movement_acceleration = 5
var player
var aim_point

func _ready():
	if !is_network_master():
		queue_free()
		return
	defaultPosition = $"../defaultPosition"
	aimPosition = $"../aimPosition"
	rayPosition = $"../RaycastPosition"
	aim_point = $PlayerUI/AimPoint


func _process(_delta):
	if !is_network_master():
		queue_free()
		return
		
	handle_aim_point()

func handle_aim_point():
	if player.is_aiming and not aim_point.visible:
		aim_point.show()
	elif not player.is_aiming and aim_point.visible:
		aim_point.hide()

func _physics_process(delta):
		if player.is_aiming:
			rayPosition.transform.origin = aimPosition.transform.origin
			transform.origin = transform.origin.linear_interpolate(aimPosition.transform.origin, delta * movement_acceleration)
			rotation_degrees.x = lerp(rotation_degrees.x, aimPosition.rotation_degrees.x, delta * movement_acceleration)
		else: 
			rayPosition.transform.origin = defaultPosition.transform.origin
			transform.origin = transform.origin.linear_interpolate(defaultPosition.transform.origin, delta * movement_acceleration)
			rotation_degrees.x = lerp(rotation_degrees.x, defaultPosition.rotation_degrees.x, delta * movement_acceleration)
		rayPosition.transform.origin.z -= 100
