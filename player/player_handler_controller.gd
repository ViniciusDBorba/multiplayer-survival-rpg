extends HandlerMachine

onready var health_handler = $HealthHandler
onready var weapon_handler = $WeaponHandler
onready var inventory_handler = $InventoryHandler

func initialize():
	health_handler.initialize(self)
	weapon_handler.initialize(self)
	inventory_handler.initialize(self)

func remove_health(damage):
	health_handler.remove_health(damage)

func add_health(health_quantity):
	health_handler.add_health(health_quantity)

func add_close_item(item_node):
	inventory_handler.add_close_item(item_node)
	
func remove_close_item(item_node):
	inventory_handler.remove_close_item(item_node)
	
func equip_weapon(weapon):
	if !weapon_handler.has_equiped_weapon() and !weapon_handler.has_holster_weapon():
		weapon.toggle_body_mode()
	weapon_handler.equip_weapon(weapon)
	
func need_health():
	return health_handler.need_health()
