extends Resource

export(bool) var has_item
export(int) var item_id
export(ItemResource.item_types) var item_type
export(int) var store_position = 0
export(int)	var quantity = 0


func _init(has_item = false, item_id = 0, store_position = 0, quantity = 0):
	self.has_item = has_item
	self.item_id = item_id
	self.item_type = ItemResource.item_types.DEFAULT
	self.store_position = store_position
	self.quantity = quantity
