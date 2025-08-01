extends Node

# The main script that controls the flow of the game.

# INTERACTION_MODE encodes the menu states the main battle menu can be in.
# Since RUN isn't a special menu, it does not get an entry here
enum INTERACTION_MODE {NONE, FIGHT, ITEM, MON}

var game_state: GameState
var rng: RandomNumberGenerator

func _ready():
	# Connect signal listeners
	Events.request_menu_fight.connect(handle_request_menu_fight)
	Events.request_menu_run.connect(handle_run)
	Events.request_menu_monsters.connect(handle_request_menu_monsters)
	Events.request_menu_option_by_index.connect(handle_request_menu_option_by_index)
	Events.on_ui_ready.connect(setup_model)
	
func _process(_delta: float):
	if !game_state.is_player_turn:
		run_ai_turn()
	
func setup_model():
	game_state = GameState.new()
	rng = RandomNumberGenerator.new()
	
	Events.on_new_game_state_created.emit()
	
	var species_salamander = preload("res://content/species/salamander.tres")
	var species_turtle = preload("res://content/species/turtle.tres")
	var species_dino = preload("res://content/species/dino.tres")
	
	var monster1 = MonsterController.create_monster(species_salamander)
	var monster2 = MonsterController.create_monster(species_turtle, "Reggie")
	var monster3 = MonsterController.create_monster(species_dino, "Steven")
	
	game_state.player = TrainerController.create_trainer([monster2, monster3], true)
	game_state.opponent = TrainerController.create_trainer([monster1], false)
	
	game_state.is_player_turn = game_state.player_monster.speed >= game_state.opponent_monster.speed
	return
	
func handle_request_menu_fight():
	var labels: Array[StringEnabled] = []
	
	for move in game_state.player.current_monster.moves:
		var label = StringEnabled.new(move.resource.name, move.usages > 0)
		labels.append(label)
	
	Events.on_menu_fight.emit(labels)
	
func handle_request_menu_monsters():
	var labels: Array[StringEnabled] = []
	for monster in game_state.player.monsters:
		labels.append(StringEnabled.new(monster.name,  monster.hp > 0))
	Events.on_menu_select_monster.emit(labels)

func handle_request_menu_option_by_index(mode: INTERACTION_MODE, index: int):
	# Just handling player case here
	match(mode):
		INTERACTION_MODE.MON:
			TrainerController.add_trainer_monster_to_battle(game_state.player, index)
		INTERACTION_MODE.FIGHT:
			MonsterController.use_monster_move_at_index(game_state.player.current_monster, index)
	
	Events.on_menu_option_selected.emit()

func handle_run():
	Events.request_log.emit("You run away. Your cowardice will not be forgotten")
	
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 2.0
	timer.timeout.connect(func(): get_tree().quit())
	timer.start()
	
func on_turn_ended():
	game_state.is_player_turn = !game_state.is_player_turn

func run_ai_turn():
	var legal_move_indices = game_state.opponent_monster.get_legal_move_indices()
	if legal_move_indices.size() <= 0:
		# TODO: allow some sort of struggle move?
		Events.request_log.emit("Can't act! No moves.")
		on_turn_ended()
	else:
		var move_index = legal_move_indices.pick_random()
		MonsterController.use_monster_move_at_index(game_state.opponent_monster, move_index)
	
