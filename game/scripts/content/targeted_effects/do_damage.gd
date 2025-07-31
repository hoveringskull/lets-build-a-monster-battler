class_name DoDamage extends TargetedEffect

@export var base_damage: int

func _do(doer: Monster, source: Move, game_state: GameState):
	var target = MonsterController.get_monster_opponent(doer)
	var amt = base_damage
	MonsterController.adjust_monster_hitpoints(target, -base_damage)
	Events.request_log.emit("{doer_name} hits {target_name} for {amt} damage"\
		.format({"doer_name": doer.name, "target_name": target.name, "amt": amt}))
