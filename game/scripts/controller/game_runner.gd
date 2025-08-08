extends Node

# The main script that controls the flow of the game.

# INTERACTION_MODE encodes the menu states the main battle menu can be in.
# Since RUN isn't a special menu, it does not get an entry here
enum INTERACTION_MODE {NONE, FIGHT, ITEM, MON, MOVE_REPLACE}

enum PHASE {AWAIT_INPUT, RESOLVE_ROUND, AWAIT_AVFX, GAME_OVER}

var current_phase: PHASE

var game_state: GameState
var rng: RandomNumberGenerator


func _ready():
	# Connect signal listeners
	Events.request_menu_fight.connect(handle_request_menu_fight)
	Events.request_menu_run.connect(handle_run)
	Events.request_menu_monsters.connect(handle_request_menu_monsters)
	Events.request_menu_items.connect(handle_request_menu_items)
	Events.request_menu_option_by_index.connect(handle_request_menu_option_by_index)
	Events.request_restart_game.connect(handle_restart)
	Events.request_quit.connect(handle_quit)
	Events.on_avfx_block_start.connect(func(): current_phase = PHASE.AWAIT_AVFX)
	Events.on_avfx_block_end.connect(func(): current_phase = PHASE.AWAIT_INPUT)
	Events.on_avfx_function.connect(handle_avfx_function)
	
	Events.on_ui_ready.connect(setup_model)
	
func _process(_delta: float):
	if current_phase == PHASE.AWAIT_INPUT:	
		if game_state.opponent.chosen_action_type == INTERACTION_MODE.NONE:
			choose_ai_move()
		if game_state.player.chosen_action_type != INTERACTION_MODE.NONE:
			current_phase = PHASE.RESOLVE_ROUND
	elif current_phase == PHASE.RESOLVE_ROUND:
		resolve_round()
		if current_phase != PHASE.GAME_OVER:
			current_phase = PHASE.AWAIT_INPUT
	elif current_phase == PHASE.AWAIT_AVFX:
		return
	else:
		return
	
func setup_model():
	game_state = GameState.new()
	rng = RandomNumberGenerator.new()
	
	Events.on_new_game_state_created.emit()
	
	var start_state = preload("res://content/start_state/default.tres")
	
	generate_state_from_start_state(start_state)

	current_phase = PHASE.AWAIT_INPUT

func generate_state_from_start_state(start_state: StartState):
	game_state.player = start_state.player_start_state.generate_trainer(true)
	game_state.opponent = start_state.opponent_start_state.generate_trainer(false)

func handle_request_menu_fight():
	if current_phase != PHASE.AWAIT_INPUT:
		return

	var labels: Array[StringEnabled] = []
	
	for move in game_state.player.current_monster.moves:
		var label = StringEnabled.new(move.resource.name, move.usages > 0)
		labels.append(label)
		
	if labels.any(func(l): return l.enabled):
		Events.on_menu_fight.emit(labels)
	else:
		# Fallback to default move
		TrainerController.set_current_monster_move(game_state.player, -1)

func handle_request_menu_monsters():
	if current_phase != PHASE.AWAIT_INPUT:
		return
		
	var labels: Array[StringEnabled] = []
	for monster in game_state.player.monsters:
		labels.append(StringEnabled.new(monster.name,  monster.hp > 0))
	Events.on_menu_select_monster.emit(labels)

func handle_request_menu_items():
	if current_phase != PHASE.AWAIT_INPUT:
		return

	var labels: Array[StringEnabled] = []
	for item in game_state.player.items:
		labels.append(StringEnabled.new(item.name + " x" + str(item.quantity), true))
	Events.on_menu_items.emit(labels)

		
func handle_request_menu_option_by_index(mode: INTERACTION_MODE, index: int):
	if current_phase != PHASE.AWAIT_INPUT:
		return
	# Just handling player case here
	match(mode):
		INTERACTION_MODE.MON:
			TrainerController.set_add_trainer_monster_to_battle(game_state.player, index)
		INTERACTION_MODE.FIGHT:
			TrainerController.set_current_monster_move(game_state.player, index)
		INTERACTION_MODE.ITEM:
			TrainerController.set_use_item_at_index(game_state.player, index)
		INTERACTION_MODE.MOVE_REPLACE:
			MonsterController.set_monster_move_at_index_to_pending_move(game_state.player_monster, index)
	
	Events.on_menu_option_selected.emit()

func handle_run():
	if current_phase != PHASE.AWAIT_INPUT:
		return

	var choice_run = ChoiceResource.new("> Leave", handle_quit)
	var choice_cancel = ChoiceResource.new("> Cancel", func(): return)
	AVFXManager.queue_avfx_message("If you run away, your cowardice will not be forgotten", [choice_run, choice_cancel])
	
	

func handle_quit():
	get_tree().quit()

func handle_restart():
	setup_model()

func choose_ai_move() -> void:
	var legal_move_indices = game_state.opponent_monster.get_legal_move_indices()
	if legal_move_indices.size() <= 0:
		TrainerController.set_current_monster_move(game_state.opponent, -1)
	else:
		var move_index = legal_move_indices.pick_random()
		TrainerController.set_current_monster_move(game_state.opponent, move_index)
	
func resolve_round():
	var player_goes_first = does_player_go_first()
	
	if player_goes_first:
		TrainerController.do_trainer_turn(game_state.player)
		TrainerController.do_trainer_turn(game_state.opponent)
	else:
		TrainerController.do_trainer_turn(game_state.opponent)
		TrainerController.do_trainer_turn(game_state.player)

	
	var quit_choice = ChoiceResource.new("> Quit", handle_quit)
	var restart_choice = ChoiceResource.new("> Restart", handle_restart)
	
	if game_state.player_monster.hp == 0:
		MonsterController.add_experience_to_monster(game_state.opponent_monster, Calculations.experience_value_of_monster(game_state.player_monster))
		var next_index = TrainerController.get_next_useable_monster_index(game_state.player)
		if next_index == -1:
			current_phase = PHASE.GAME_OVER
			Events.on_game_over.emit(false)
			
			AVFXManager.queue_avfx_message("You lose!", [quit_choice, restart_choice])
			
		else:
			TrainerController.add_trainer_monster_to_battle(game_state.player, next_index)
	
	if game_state.opponent_monster.hp == 0:
		MonsterController.add_experience_to_monster(game_state.player_monster, Calculations.experience_value_of_monster(game_state.opponent_monster))
		var next_index = TrainerController.get_next_useable_monster_index(game_state.opponent)
		if next_index == -1:
			current_phase = PHASE.GAME_OVER
			Events.on_game_over.emit(true)
			AVFXManager.queue_avfx_message("You win!", [quit_choice, restart_choice])
		else:
			TrainerController.add_trainer_monster_to_battle(game_state.opponent, next_index)
	
	var update_player_mon = AVFXFunction.new(func(): Events.on_monster_updated.emit(game_state.player_monster))
	var update_opponent_mon = AVFXFunction.new(func(): Events.on_monster_updated.emit(game_state.opponent_monster))
	
	AVFXManager.queue_avfx_effect_group([update_player_mon, update_opponent_mon], null)	


func does_player_go_first() -> bool:
	assert(game_state.player.chosen_action_type != INTERACTION_MODE.NONE)
	assert(game_state.opponent.chosen_action_type != INTERACTION_MODE.NONE)
	
	if game_state.player.chosen_action_type == INTERACTION_MODE.ITEM \
		or game_state.player.chosen_action_type == INTERACTION_MODE.MON:
			return true
		
	if game_state.opponent.chosen_action_type == INTERACTION_MODE.ITEM \
		or game_state.opponent.chosen_action_type == INTERACTION_MODE.MON:
			return false

	var player_move = MonsterController.get_monster_move_at_index(game_state.player.current_monster, game_state.player.chosen_action_index)
	var opponent_move = MonsterController.get_monster_move_at_index(game_state.opponent.current_monster, game_state.opponent.chosen_action_index)

	if player_move.move_priority > opponent_move.move_priority:
		return true
	elif player_move.move_priority < opponent_move.move_priority:
		return false
	else:
		return game_state.player_monster.speed >= game_state.opponent_monster.speed
	
func handle_avfx_function(instance: AVFXInstance, function: Callable):
	if instance.resource.delay == 0:
		call_avfx_function(instance, function)
	else:
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = instance.resource.delay
		timer.one_shot = true
		timer.timeout.connect(func(): call_avfx_function(instance, function))
		timer.start()

func call_avfx_function(instance: AVFXInstance, function: Callable):
	function.call()
	instance.finish()
