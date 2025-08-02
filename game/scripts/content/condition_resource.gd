class_name ConditionResource extends Resource

@export var name: String
@export var stat_modifiers: Array[StatModifier]
@export var on_begin_turn_effects: Array[TargetedEffect]
@export var duration: int
@export var max_stacks: int = 1
@export var short_name: String
