class_name MonsterStartState extends Resource

@export var nickname: String
@export var species: SpeciesResource
@export var level: int

func generate() -> Monster:
	var monster = MonsterController.create_monster(species, nickname)
	monster.level = level
	monster.hp = monster.max_hp
	return monster
