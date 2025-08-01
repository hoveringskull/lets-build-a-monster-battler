class_name DoDamage extends TargetedEffect

@export var base_damage: int

func _do(doer: Monster, source: Move, game_state: GameState):
	var target = doer if target_self else MonsterController.get_monster_opponent(doer)
	
	var type_advantage_coefficient = MonsterType.get_type_advantage_coefficient(source.type, target.type)
	var stat_diff_coefficient = doer.attack / max(1, target.defence)

	var amt = base_damage * type_advantage_coefficient * stat_diff_coefficient
	MonsterController.adjust_monster_hitpoints(target, -amt)
	
	var effectiveness = MonsterType.get_type_effectiveness(source.type, target.type)
	
	if effectiveness == MonsterType.Effectiveness.STRONG:
		Events.request_log.emit("It's extra effective!")
	elif effectiveness == MonsterType.Effectiveness.WEAK:
		Events.request_log.emit("It's not very effective at all.")

	
	Events.request_log.emit("{doer_name} hits {target_name} for {amt} damage"\
		.format({"doer_name": doer.name, "target_name": target.name, "amt": amt}))
