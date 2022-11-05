extends Spatial

export(ItemResource.item_types) var item_type
var number_generator
var item_ids = []

signal spawn_item(item_id, item_type, position)

func _ready():
	number_generator = RandomNumberGenerator.new()
	find_items_ids_in_folder()
	spawn_item()

func find_items_ids_in_folder():
	var resources_path = "res://Resources/Items/" + ItemResource.item_type_name(item_type) + "/Infos"
	var dir = Directory.new()
	var error = dir.open(resources_path)
	if error:
		printerr(error)
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			break
		var item_id = file_name.split(".")[0]
		if (file_name.split(".")[1] == "tres"):
			item_ids.append(item_id)
	dir.list_dir_end()

func spawn_item():
	var item = instace_base_item()
	var item_id = get_ramdom_item_id()
	
	item.item_id = item_id
	item.item_type = item_type
	item.add_child(instance_item_model(item_id, item_type))
	item.add_child(instance_item_collision(item_id, item_type))
	var test_scene = get_node("/root")
	test_scene.add_child(item)
	item.transform.origin = self.transform.origin

func get_ramdom_item_id():
	var i = number_generator.randi_range(0, item_ids.size() - 1)
	return item_ids[i]

func instace_base_item():
	var base_item = preload("res://Nodes/Items/BaseItem.tscn")
	return base_item.instance()

func instance_item_model(item_id, model_item_type):
	var models_path = "res://Models/Items/" + ItemResource.item_type_name(model_item_type) + "/"
	return load(models_path + item_id + "_model.tscn").instance()
	
func instance_item_collision(item_id, collision_item_type):
	var collisions_path = "res://Models/Items/" + ItemResource.item_type_name(collision_item_type) + "/Collisions/"
	return load(collisions_path + item_id + "_collision.tscn").instance()
