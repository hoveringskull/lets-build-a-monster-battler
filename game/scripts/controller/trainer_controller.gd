extends Node

var game_state: GameState
var rng: RandomNumberGenerator

func _ready():
	Events.on_new_game_state_created.connect(get_controller_components)

func get_controller_components():
	game_state = GameRunner.game_state
	rng = GameRunner.rng
	
func create_trainer(monsters: Array[Monster], is_player: bool) -> Trainer:
	var trainer = Trainer.new()
	trainer.is_player = is_player
	trainer.monsters = monsters
	add_trainer_monster_to_battle(trainer, 0)
	return trainer

func add_trainer_monster_to_battle(trainer: Trainer, monster_index: int):
	var monster = trainer.monsters[monster_index]
	trainer.current_monster_index = monster_index
	Events.on_monster_added_to_battle.emit(monster, trainer.is_player)

func get_next_useable_monster_index(trainer: Trainer) -> int:
	for index in range(trainer.monsters.size()):
		if trainer.monsters[index].hp > 0:
			return index
	return -1
	
