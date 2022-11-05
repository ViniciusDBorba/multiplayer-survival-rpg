extends Node

class_name Factions

enum player_factions {
	MILITARY = 1,
	OUTLAWS = 2,
	RENEGADES = 3,
}

func get_faction_name(faction):
	if faction == player_factions.MILITARY:
		return $"root/TextHandler".get_text("militaries")
	elif faction == player_factions.OUTLAWS:
		return $"root/TextHandler".get_text("outlaws")
	elif faction == player_factions.RENEGADES:
		return $"root/TextHandler".get_text("renegades")
		
static func get_faction_value(selected):

	if selected == "militaries":
		return player_factions.MILITARY
	elif selected == "outlaws":
		return player_factions.OUTLAWS
	elif selected == "renegades":
		return player_factions.RENEGADES
