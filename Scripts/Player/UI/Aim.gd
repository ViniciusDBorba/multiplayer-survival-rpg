extends RichTextLabel

var cam
var aim_point_position

func _ready():
	aim_point_position = $"../../../RaycastPosition"
	cam = $"../.."

func _physics_process(_delta):
	var aim_rect_position = cam.unproject_position(aim_point_position.global_transform.origin)
	aim_rect_position.x += 4
	aim_rect_position.y -= 16
	rect_position = aim_rect_position

