class_name Monster

var species: SpeciesResource
var hp: int
var nickname: String
var moves: Array[Move]
var conditions: Array[Condition]

var image: Texture2D:
	get: return species.image
	
var name: String:
	get: return nickname if nickname else species.name

var type: MonsterType.Type:
	get: return species.type

var max_hp: int:
	get: return clamp(species.base_max_hp + sum_condition_stats_for_code(Stat.Code.MAX_HP), 1, 999)

var attack: int:
	get: return clamp(species.base_attack + sum_condition_stats_for_code(Stat.Code.ATK), 1, 999)
	
var defence: int:
	get: return clamp(species.base_defence + sum_condition_stats_for_code(Stat.Code.DEF), 1, 999)
	
var speed: int:
	get: return clamp(species.base_speed + sum_condition_stats_for_code(Stat.Code.SPD), 1, 999)

func get_legal_move_indices() -> Array[int]:
	var legal_indices: Array[int] = []
	for i in range(0, moves.size()):
		if moves[i] and moves[i].usages > 0:
			legal_indices.append(i)
	return legal_indices

func sum_condition_stats_for_code(code: Stat.Code):
	var sum = 0
	for condition in conditions:
		for stat_modifier in condition.resource.stat_modifiers:
			if stat_modifier.stat == code:
				sum += stat_modifier.modifier
	return sum

func dump_state():
	var condition_string = ""
	
	for condition in conditions:
		condition_string += condition.name + "\n"
	
	return "Name: {name}\n Hp:({hp}/{max_hp})\n ATK: {attack} \n DEF: {defence} \n SPD: {speed} \n Conditions:\n {conditions}"\
		.format({
			"name": name,
			"attack": attack,
			"defence": defence,
			"speed": speed,
			"hp": hp,
			"max_hp": max_hp,
			"conditions": condition_string
		})
