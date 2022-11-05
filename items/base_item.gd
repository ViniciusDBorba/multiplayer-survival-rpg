extends RigidBody

#Item values
export var item_id = "Item name"
export(ItemResource.item_types) var item_type

#Logic references
onready var highlight_shader = preload("res://items/shaders/highlight_shader_material.tres")

func toggle_body_mode():
	match mode:
		RigidBody.MODE_KINEMATIC:
			$PlayerDetection/DetectionArea.disabled = false
			mode = RigidBody.MODE_RIGID
			get_node(item_id + "_collision").disabled = false
		RigidBody.MODE_RIGID:
			$PlayerDetection/DetectionArea.disabled = true
			mode = RigidBody.MODE_KINEMATIC
			get_node(item_id + "_collision").disabled = true

func get_shoot_position():
	return get_node(item_id + "_model/shootPosition").transform.origin

func toggle_higlight():
	var model = get_node(item_id + "_model")
	if model.material_override:
		model.material_override = null
	else:
		model.material_override = highlight_shader

func body_enter_area(body):
	if body.is_in_group("Player"):
		body.add_close_item(self)

func body_exit_area(body):
	if body.is_in_group("Player"):
		body.remove_close_item(self)
