extends Node

# The main script that controls the flow of the game.

# INTERACTION_MODE encodes the menu states the main battle menu can be in.
# Since RUN isn't a special menu, it does not get an entry here
enum INTERACTION_MODE {NONE, FIGHT, ITEM, MON}

var game_state

func _ready():
	# Connect signal listeners
	Events.request_menu_fight.connect(handle_request_menu_fight)
	Events.request_menu_run.connect(handle_run)
	
	setup_model()
	
func setup_model():
	game_state = GameState.new()
	
	var species_salamander = preload("res://content/species/salamander.tres")
	var species_turtle = preload("res://content/species/turtle.tres")
	
	var monster1 = Monster.new()
	monster1.species = species_salamander
	monster1.hp = species_salamander.max_hp
	
	var monster2 = Monster.new()
	monster2.species = species_turtle
	monster2.hp = species_turtle.max_hp
	
	game_state.player_monster = monster1
	game_state.opponent_monster = monster2
	return
	
func handle_request_menu_fight():
	var labels: Array[StringEnabled] = [StringEnabled.new("A", true), StringEnabled.new("B", false)]
	Events.on_menu_fight.emit(labels)

func handle_run():
	get_tree().quit()
