extends Node

var game_state: GameState

func _ready():
	Events.on_new_game_state_created.connect(func(state): game_state = state)

func create_monster(species: SpeciesResource, nickname: String = "") -> Monster:
	var monster = Monster.new()
	monster.species = species
	monster.hp = species.max_hp
	monster.nickname = nickname
	
	return monster
