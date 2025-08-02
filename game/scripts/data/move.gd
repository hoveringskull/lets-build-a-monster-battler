class_name Move

@export var usages: int
@export var resource: MoveResource

var type: MonsterType.Type:
	get: return resource.type
	
var name: String:
	get: return resource.name

var use_message: String:
	get: return resource.use_message

var base_accuracy: float:
	get: return resource.base_accuracy

var move_priority: int:
	get: return resource.move_priority

# Used for duck-typing in TargetedEffect
func get_type() -> MonsterType.Type:
	return type
