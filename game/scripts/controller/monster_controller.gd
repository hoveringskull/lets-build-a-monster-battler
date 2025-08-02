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
	
	if monster.hp == 0:
		faint_monster(monster)

	Events.on_monster_updated.emit(monster)

func faint_monster(monster: Monster):
	return

func get_monster_move_at_index(monster: Monster, index: int) -> Move:
	return monster.moves[index]

func use_monster_move(monster: Monster, move: Move):
	if move.usages <= 0 or monster.hp == 0:
		return

	var use_string = move.use_message.format({"user_name": monster.name, "move_name": move.name})
	Events.request_log.emit(use_string)

	var opponent = get_monster_opponent(monster)
	if opponent.hp == 0:
		monster.move_blocked = false
		return

	if monster.move_blocked:
		Events.request_log.emit("But they can't move!")
		monster.move_blocked = false
		return

	move.usages -= 1
	
	var hit = rng.randf() < move.base_accuracy
	if !hit:
		Events.request_log.emit("But it misses")
	
	var crit = rng.randf() < Calculations.get_crit_chance(monster)
	if crit:
		Events.request_log.emit("Critical hit!")
	
	AVFXManager.queue_avfx_effect_group(move.resource.use_avfx, monster)
	
	for effect in move.resource.use_effects:
		if effect._should_do(hit, crit):
			effect._do(monster, move, game_state, crit)
	
	
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
	
	monster.fallback_move = Move.new()
	monster.fallback_move.resource = preload("res://content/moves/struggle.tres")
	monster.fallback_move.usages = 999

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
	
func do_monster_turn(monster: Monster):
	on_turn_begun(monster)
	use_monster_move(monster, monster.chosen_move)
	monster.chosen_move = null
	return

func on_turn_begun(monster: Monster):
	if monster.hp == 0:
		return
	for condition in monster.conditions:
		for effect in condition.resource.on_begin_turn_effects:
			effect._do(monster, condition, game_state, false)
		condition.duration_remaining -= 1
		if condition.duration_remaining <= 0:
			end_condition(monster, condition)


func end_condition(monster: Monster, condition: Condition):
	monster.conditions.remove_at(monster.conditions.find(condition))
	
	Events.on_monster_updated.emit(monster)
