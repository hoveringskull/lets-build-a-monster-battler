class_name DoDamage extends TargetedEffect

@export var base_damage: int
@export var ignore_stats: bool
@export var damage_log_string: String = "{doer_name} hits {target_name} for {amt} damage"
@export var critical_hit_damage_coefficient = 1.5

func _do(doer: Monster, source: Object, game_state: GameState, is_critical: bool, logs: Array[String]):
	var target = doer if target_self else MonsterController.get_monster_opponent(doer)
	var type = source.get_type() if source.has_method("get_type") else MonsterType.Type.NORMAL
	
	var type_advantage_coefficient = MonsterType.get_type_advantage_coefficient(type, target.type)
	var stat_diff_coefficient = 1 if ignore_stats else doer.attack / max(1, target.defence)
	var crit_coefficient = critical_hit_damage_coefficient if is_critical else 1

	var amt = base_damage * type_advantage_coefficient * stat_diff_coefficient * crit_coefficient
	MonsterController.adjust_monster_hitpoints(target, -amt)
	
	var effectiveness = MonsterType.get_type_effectiveness(type, target.type)
	
	if effectiveness == MonsterType.Effectiveness.STRONG:
		logs.append("It's extra effective!")
	elif effectiveness == MonsterType.Effectiveness.WEAK:
		logs.append("It's not very effective at all.")

	logs.append(damage_log_string\
		.format({"doer_name": doer.name, "target_name": target.name, "amt": amt}))
