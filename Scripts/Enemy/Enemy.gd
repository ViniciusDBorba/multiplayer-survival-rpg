extends KinematicBody

export var health = 100

func apply_damage(damage):
	health -= damage

func _process(delta):
	if health <= 0:
		rotation_degrees.x = lerp(rotation_degrees.x, -90, delta * 10)


