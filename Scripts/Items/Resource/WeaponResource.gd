extends ItemResource

enum weapon_types {
	FIRE = 0,
	WHITE = 1
}

export(weapon_types) var weapon_type
export(float) var damage

func _init():
	type = item_types.WEAPON


