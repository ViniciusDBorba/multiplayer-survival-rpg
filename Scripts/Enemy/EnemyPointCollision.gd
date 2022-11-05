extends CollisionShape

export var point_name = "damage"
export var point_damage = 80

var enemy

func _ready():
	enemy = $".."

func receive_damage(bullet_damage):
	var damage =  bullet_damage + point_damage
	enemy.apply_damage(damage)
