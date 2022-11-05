tool
extends Spatial

export(ItemResource.item_types) var item_type setget _set_item_type
var item_ids = []

func _ready():
	spawn_item()

func _set_item_type(new_item_type):
	item_type = new_item_type
	spawn_item()

func find_items_ids_in_folder():
	var resources_path = "res://Resources/Items/" + ItemResource.item_type_name(self.item_type) + "/Infos"
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
			self.item_ids.append(item_id)
	dir.list_dir_end()

func spawn_item():
	if get_child_count() > 0:
		return

	find_items_ids_in_folder()
	var item = instace_base_item()
	var item_id = get_ramdom_item_id()
	
	item.item_id = item_id
	item.item_type = self.item_type
	item.add_child(instance_item_model(item_id))
	item.add_child(instance_item_collision(item_id))
	if get_child_count() > 0:
		get_child(0).queue_free()
	add_child(item)
	item.transform.origin = Vector3.ZERO

func get_ramdom_item_id():
	var number_generator = RandomNumberGenerator.new()
	var i = number_generator.randi_range(0, self.item_ids.size() - 1)
	return self.item_ids[i]

func instace_base_item():
	var base_item = preload("res://items/BaseItem.tscn")
	return base_item.instance()

func instance_item_model(item_id):
	if !item_id:
		return
	var models_path = "res://Models/Items/" + ItemResource.item_type_name(self.item_type) + "/"
	return load(models_path + item_id + "_model.tscn").instance()
	
func instance_item_collision(item_id):
	if !item_id:
		return
	var collisions_path = "res://Models/Items/" + ItemResource.item_type_name(self.item_type) + "/Collisions/"
	return load(collisions_path + item_id + "_collision.tscn").instance()
