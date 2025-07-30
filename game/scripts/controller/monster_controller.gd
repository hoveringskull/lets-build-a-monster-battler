extends Node

var game_state: GameState

func _ready():
	Events.on_new_game_state_created.connect(func(state): game_state = state)

func create_monster(species: SpeciesResource, nickname: String = "") -> Monster:
	var monster = Monster.new()
	monster.species = species
	monster.hp = species.max_hp
	monster.nickname = nickname
	var moves: Array[Move] = []
	
	for move_resource in species.starter_moves:
		var move = Move.new()
		move.resource = move_resource
		move.usages = move_resource.usage_max
		moves.append(move)
	
	monster.moves = moves
	
	return monster
