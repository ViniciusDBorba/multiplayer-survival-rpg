extends Handler

export(float) var total_health = 100
export(float) var health = 100.0 setget _set_health

func initialize(handler_machine):
	.initialize(handler_machine)
	self.health = total_health

func need_health():
	return self.health < total_health

func max_health():
	self.health = total_health

func add_health(extra_health):
	if !need_health():
		return
	elif (health + extra_health) > total_health:
		max_health()
	else:
		self.health = self.health + extra_health
		
	if is_network_master():
		rpc("update_health", self.health)

func remove_health(minus_health):
	self.health = self.health - minus_health
	
	if self.health <= 0:
		self.health = 0
		owner.die()

puppet func update_health(new_health):
	self.health = new_health

func _set_health(new_health):
	if owner.name != str(get_tree().get_network_unique_id()):
		return
	health = new_health
	get_tree().call_group("player_ui", "update_health", self.health)
