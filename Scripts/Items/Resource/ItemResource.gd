extends Resource

class_name ItemResource

enum item_types {
	DEFAULT = 0,
	HEALTH = 1,
	WEAPON = 2
}

#Item values
export(String) var item_id
export(String) var item_name
export(bool) var can_use_item
export(int) var item_max_stack
export(item_types) var type = item_types.DEFAULT

static func item_type_name(item_type):
	match item_type:
		item_types.DEFAULT:
			return "Default"
		item_types.HEALTH:
			return "Health"
		item_types.WEAPON:
			return "Weapon"
