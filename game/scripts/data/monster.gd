class_name Monster

var species: SpeciesResource
var hp: int
var nickname: String
var moves: Array[Move]
var conditions: Array[Condition]
var experience: int
var level: int = 1
var fallback_move

var hp_growth: float
var atk_growth: float
var def_growth: float
var spd_growth: float


# ephemeral state, cleared after each turn
var pending_moves: Array[MoveResource]
var pending_move: MoveResource
var move_blocked

var image: Texture2D:
	get: return species.image
	
var name: String:
	get: return nickname if nickname else species.name

var type: MonsterType.Type:
	get: return species.type

var max_hp: int:
	get: return Calculations.calculate_monster_stat(species.base_max_hp, hp_growth, level, sum_condition_stats_for_code(Stat.Code.MAX_HP))

var attack: int:
	get: return Calculations.calculate_monster_stat(species.base_attack, atk_growth, level, sum_condition_stats_for_code(Stat.Code.ATK))
	
var defence: int:
	get: return Calculations.calculate_monster_stat(species.base_defence, def_growth, level, sum_condition_stats_for_code(Stat.Code.DEF))
	
var speed: int:
	get: return Calculations.calculate_monster_stat(species.base_speed, spd_growth, level, sum_condition_stats_for_code(Stat.Code.SPD))

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

func get_condition_string():
	if conditions.size() == 0:
		return "Lv1"
	else:
		return conditions[0].resource.short_name

func dump_state():
	var condition_string = ""
	
	for condition in conditions:
		condition_string += "{name} - ({remaining})\n".format({"name": condition.name, "remaining": condition.duration_remaining})
	
	return "Name: {name}\nHp:({hp}/{max_hp})\nATK: {attack} \nDEF: {defence} \nSPD: {speed} \nConditions:\n{conditions}"\
		.format({
			"name": name,
			"attack": attack,
			"defence": defence,
			"speed": speed,
			"hp": hp,
			"max_hp": max_hp,
			"conditions": condition_string
		})
