extends State

class_name Motion

var fall_acceleration = 75

func get_input_directions():
	var input_directions = {}
	input_directions.right = Input.is_action_pressed("move_right")
	input_directions.left = Input.is_action_pressed("move_left")
	input_directions.back = Input.is_action_pressed("move_back")
	input_directions.forward = Input.is_action_pressed("move_forward")
	return input_directions
	
func is_moving():
	var input_directions = get_input_directions()
	if input_directions.left:
		return true
	if input_directions.right:
		return true
	if input_directions.forward:
		return true
	if input_directions.back:
		return true
	return false
