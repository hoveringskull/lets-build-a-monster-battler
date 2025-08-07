class_name SpeciesResource extends Resource

@export var image: Texture2D
@export var name: String
@export var starter_moves: Array[MoveResource]
@export var type: MonsterType.Type

@export var base_max_hp: int
@export var base_attack: int
@export var base_defence: int
@export var base_speed: int

@export var moves_learned_by_level: Array[IntMoveResource]
