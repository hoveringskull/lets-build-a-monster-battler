class_name DoHeal extends TargetedEffect

@export var base_heal: int

func _do(doer: Monster, source: Object, game_state: GameState, is_critical: bool):
	var target = doer if target_self else MonsterController.get_monster_opponent(doer)
			
	var amt = base_heal
	MonsterController.adjust_monster_hitpoints(target, amt)
	
	Events.request_log.emit("{doer_name} heals {target_name} for {amt} damage"\
		.format({"doer_name": doer.name, "target_name": target.name, "amt": amt}))
