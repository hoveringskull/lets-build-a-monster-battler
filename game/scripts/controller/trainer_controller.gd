extends Node

var game_state: GameState

func _ready():
	Events.on_new_game_state_created.connect(func(state): game_state = state)

func add_trainer_monster_to_battle(trainer: Trainer, monster_index: int):
	var monster = game_state.player.monsters[monster_index]
	game_state.player.current_monster = monster
	Events.on_monster_added_to_battle.emit(monster, true)
