class_name Trainer

var name: String
var monsters: Array[Monster] = []
var current_monster_index: int = 0
var is_player: bool
var items: Array[Item] = []

var chosen_action_type: GameRunner.INTERACTION_MODE = GameRunner.INTERACTION_MODE.NONE
var chosen_action_index: int = -1

var current_monster: Monster:
	get: return monsters[current_monster_index]
