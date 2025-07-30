extends Node

# The main script that controls the flow of the game.

# INTERACTION_MODE encodes the menu states the main battle menu can be in.
# Since RUN isn't a special menu, it does not get an entry here
enum INTERACTION_MODE {NONE, FIGHT, ITEM, MON}

var game_state: GameState

func _ready():
	# Connect signal listeners
	Events.request_menu_fight.connect(handle_request_menu_fight)
	Events.request_menu_run.connect(handle_run)
	Events.request_menu_monsters.connect(handle_request_menu_monsters)
	Events.request_menu_option_by_index.connect(handle_request_menu_option_by_index)
	Events.on_ui_ready.connect(setup_model)
	
func setup_model():
	game_state = GameState.new()
	
	Events.on_new_game_state_created.emit(game_state)
	
	game_state.player = Trainer.new()
	game_state.opponent = Trainer.new()
	
	var species_salamander = preload("res://content/species/salamander.tres")
	var species_turtle = preload("res://content/species/turtle.tres")
	var species_dino = preload("res://content/species/dino.tres")
	
	var monster1 = MonsterController.create_monster(species_salamander)
	var monster2 = MonsterController.create_monster(species_turtle, "Reggie")
	var monster3 = MonsterController.create_monster(species_dino, "Steven")
	
	game_state.player.monsters.append(monster1)
	game_state.player.monsters.append(monster3)
	game_state.player.current_monster = monster1
	
	Events.on_monster_added_to_battle.emit(monster1, true)
	
	game_state.opponent.monsters.append(monster2)
	game_state.opponent.current_monster = monster2

	Events.on_monster_added_to_battle.emit(monster2, false)
	
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
	
	Events.on_menu_option_selected.emit()

func handle_run():
	get_tree().quit()
