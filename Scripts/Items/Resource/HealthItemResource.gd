extends ItemResource

export(float) var health_quantity

func _init():
	type = item_types.HEALTH
	
func use(who):
	who.add_health(health_quantity)
