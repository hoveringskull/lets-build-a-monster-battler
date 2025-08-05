class_name TargetedEffect extends Resource

enum OutcomeFilter {
	HIT,
	MISS,
	BOTH,
	CRIT
}

@export var outcome_filter: OutcomeFilter
@export var target_self: bool

func _do(doer: Monster, source: Object, game_state: GameState, is_critical: bool, logs: Array[String]):
	return

func _should_do(is_hit: bool, is_critical: bool) -> bool:
	return outcome_filter == OutcomeFilter.BOTH\
		or (is_hit and outcome_filter == OutcomeFilter.HIT)\
		or (!is_hit and outcome_filter == OutcomeFilter.MISS)\
		or (is_critical and outcome_filter == OutcomeFilter.CRIT)
