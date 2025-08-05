class_name ItemResource extends Resource

@export var name: String
@export var use_effects: Array[TargetedEffect]
@export var use_avfx: Array[AVFXResource]
@export var consumable: bool = true
@export var use_message: String = "{user_name} uses {item_name}!"
