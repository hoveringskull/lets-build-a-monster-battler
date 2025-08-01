class_name Trainer

var name: String
var monsters: Array[Monster] = []
var current_monster_index: int = 0
var is_player: bool

var current_monster: Monster:
	get: return monsters[current_monster_index]
