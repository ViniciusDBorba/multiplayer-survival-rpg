extends StateMachine

onready var idle = $Idle
onready var move = $Move
onready var attack = $Attack
onready var die = $Die
onready var respawn = $Respawn

func _ready():
	states_map = {
		"idle": idle,
		"move": move,
		"attack": attack,
		"die": die,
		"respawn": respawn
	}

func _change_state(state_name):
	if not _active:
		return
	if state_name in ["attack"]:
		states_stack.push_front(states_map[state_name])
	._change_state(state_name)

func _unhandled_input(event):
	if not owner.is_aiming and event.is_action_pressed("attack"):
		if current_state in [attack]:
			return
		_change_state("attack")
		return
	current_state.handle_input(event)
