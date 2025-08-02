class_name MoveResource extends Resource

@export var name: String
@export var usage_max: int
@export var use_effects: Array[TargetedEffect]
@export var type: MonsterType.Type
@export var use_message: String = "{user_name} uses {move_name}"
@export var base_accuracy: float = 0.9 # Between 0-1
@export var move_priority: int
@export var use_avfx: Array[AVFXResource]
