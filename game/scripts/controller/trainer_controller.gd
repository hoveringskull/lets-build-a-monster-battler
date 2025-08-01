extends Node

var game_state: GameState
var rng: RandomNumberGenerator

func _ready():
	Events.on_new_game_state_created.connect(get_controller_components)

func get_controller_components():
	game_state = GameRunner.game_state
	rng = GameRunner.rng

func add_trainer_monster_to_battle(trainer: Trainer, monster_index: int):
	var monster = game_state.player.monsters[monster_index]
	game_state.player.current_monster = monster
	Events.on_monster_added_to_battle.emit(monster, true)
