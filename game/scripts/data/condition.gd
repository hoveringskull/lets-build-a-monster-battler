class_name Condition

var resource: ConditionResource
var duration_remaining: int

var name: String:
	get: return resource.name

# Used for duck-typing in TargetedEffect
func get_type() -> MonsterType.Type:
	return MonsterType.Type.NORMAL
