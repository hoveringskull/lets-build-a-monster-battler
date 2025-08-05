class_name BlockMove extends TargetedEffect

@export var chance_to_block_move: float = 0.5

func _do(doer: Monster, source: Object, game_state: GameState, is_critical: bool, logs: Array[String]):
	var target = doer if target_self else MonsterController.get_monster_opponent(doer)
	
	if GameRunner.rng.randf() < chance_to_block_move:
		target.move_blocked = true
		return
