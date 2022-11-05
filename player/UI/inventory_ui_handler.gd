extends Control

func load_item_image_texture(item_id, item_type):
	var item_image = load_item_image(item_id, item_type)
	var image_texture = ImageTexture.new()
	image_texture.create_from_image(item_image)
	image_texture.flags = image_texture.FLAG_MIPMAPS
	image_texture.set_size_override(Vector2(21, 22))
	return image_texture

func load_item_image(item_id, item_type):
	return load("res://Resources/Items/"+ ItemResource.item_type_name(item_type) +"/Images/"+item_id+".png")
