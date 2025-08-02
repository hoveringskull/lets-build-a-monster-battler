extends Node

var game_state: GameState
var rng: RandomNumberGenerator

func _ready():
	Events.on_new_game_state_created.connect(get_controller_components)

func get_controller_components():
	game_state = GameRunner.game_state
	rng = GameRunner.rng

func get_monster_opponent(monster: Monster) -> Monster:
	if monster == game_state.player_monster:
		return game_state.opponent_monster
	
	if monster == game_state.opponent_monster:
		return game_state.player_monster
		
	return 
	
func get_current_monster() -> Monster:
	if game_state.is_player_turn:
		return game_state.player_monster
	else:
		return game_state.opponent_monster
	
func adjust_monster_hitpoints(monster: Monster, amount: int):
	monster.hp = clamp(monster.hp + amount, 0, monster.max_hp)
	
	# TODO: add check for fainting
	Events.on_monster_updated.emit(monster)

func use_monster_move_at_index(monster: Monster, index: int):
	var move = monster.moves[index]
	if move.usages <= 0:
		return

	var use_string = move.use_message.format({"user_name": monster.name, "move_name": move.name})
	Events.request_log.emit(use_string)

	if monster.move_blocked:
		Events.request_log.emit("But they can't move!")
		monster.move_blocked = false
		GameRunner.on_turn_ended()
		return

	move.usages -= 1
	
	var hit = rng.randf() < move.base_accuracy
	if !hit:
		Events.request_log.emit("But it misses")
	
	for effect in move.resource.use_effects:
		if effect._should_do(hit):
			effect._do(monster, move, game_state)
	
	GameRunner.on_turn_ended()
	
func create_monster(species: SpeciesResource, nickname: String = "") -> Monster:
	var monster = Monster.new()
	monster.species = species
	monster.hp = monster.max_hp
	monster.nickname = nickname
	var moves: Array[Move] = []
	
	for move_resource in species.starter_moves:
		if move_resource == null:
			continue
		var move = Move.new()
		move.resource = move_resource
		move.usages = move_resource.usage_max
		moves.append(move)
	
	monster.moves = moves
	
	return monster

func instantiate_condition_on_monster(monster: Monster, condition_resource: ConditionResource):
	if monster.conditions\
		.filter(func(condition): return condition.resource == condition_resource)\
		.size() >= condition_resource.max_stacks:
			return
	
	var condition = Condition.new()
	condition.resource = condition_resource
	condition.duration_remaining = condition.resource.duration
	monster.conditions.append(condition)
	
	Events.on_monster_updated.emit(monster)

func end_condition(monster: Monster, condition: Condition):
	monster.conditions.remove_at(monster.conditions.find(condition))
	
	Events.on_monster_updated.emit(monster)
