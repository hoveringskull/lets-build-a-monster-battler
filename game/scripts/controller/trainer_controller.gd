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

func do_trainer_turn(trainer: Trainer):
	MonsterController.on_turn_begun(trainer.current_monster)

	match trainer.chosen_action_type:
		GameRunner.INTERACTION_MODE.FIGHT:
			var move = MonsterController.get_monster_move_at_index(trainer.current_monster, trainer.chosen_action_index)
			MonsterController.use_monster_move(trainer.current_monster, move)
		GameRunner.INTERACTION_MODE.MON:
			add_trainer_monster_to_battle(trainer, trainer.chosen_action_index)
		GameRunner.INTERACTION_MODE.ITEM:
			use_item_at_index(trainer, trainer.chosen_action_index)
	
	trainer.chosen_action_index = -1
	trainer.chosen_action_type = GameRunner.INTERACTION_MODE.NONE


func set_add_trainer_monster_to_battle(trainer: Trainer, index: int):
	var monster = trainer.monsters[index]
	
	assert(monster.hp > 0)
	
	trainer.chosen_action_index = index
	trainer.chosen_action_type = GameRunner.INTERACTION_MODE.MON

func set_use_item_at_index(trainer: Trainer, index: int):
	var item = trainer.items[index]
	
	assert(item.quantity > 0)
	
	trainer.chosen_action_index = index
	trainer.chosen_action_type = GameRunner.INTERACTION_MODE.ITEM

func add_trainer_monster_to_battle(trainer: Trainer, monster_index: int):
	var monster = trainer.monsters[monster_index]
	trainer.current_monster_index = monster_index
	Events.on_monster_added_to_battle.emit(monster, trainer.is_player)

func get_next_useable_monster_index(trainer: Trainer) -> int:
	for index in range(trainer.monsters.size()):
		if trainer.monsters[index].hp > 0:
			return index
	return -1

func set_current_monster_move(trainer: Trainer, index: int):
	var monster = trainer.current_monster
	var move = MonsterController.get_monster_move_at_index(monster, index)
	
	assert(move.usages > 0)
	
	trainer.chosen_action_index = index
	trainer.chosen_action_type = GameRunner.INTERACTION_MODE.FIGHT
	

func use_item_at_index(trainer: Trainer, index: int):
	var item = trainer.items[index]
	
	if item.quantity <= 0:
		return
	
	var logs: Array[String] = []
	
	var use_string = item.use_message.format({"user_name": trainer.name, "item_name": item.name})

	var message_avfx = AVFXMessages.new(logs as Array[String])
	var avfx_group = item.resource.use_avfx.duplicate()
	avfx_group.append(message_avfx)
	AVFXManager.queue_avfx_effect_group(avfx_group, trainer.current_monster)

	if item.resource.consumable:
		remove_item(trainer, item.resource, 1)

	for effect in item.resource.use_effects:
		if effect._should_do(true, false):
			effect._do(trainer.current_monster, item, game_state, false, logs)

func add_item(trainer: Trainer, item_resource: ItemResource, quantity: int):
	var existing_item_index = trainer.items.find_custom(func(found_item): return found_item.resource == item_resource)
	
	if existing_item_index == -1:
		# There is no matching item in the trainer's item array
		var item = Item.new()
		item.resource = item_resource
		item.quantity = quantity
		trainer.items.append(item)
	else:
		var item = trainer.items[existing_item_index]
		item.quantity += quantity
	
func remove_item(trainer: Trainer, item_resource: ItemResource, quantity: int):
	var existing_item_index = trainer.items.find_custom(func(found_item): return found_item.resource == item_resource)
	
	assert(existing_item_index > -1)
	
	var item = trainer.items[existing_item_index]
	
	assert(item.quantity >= quantity)

	item.quantity -= quantity
	if item.quantity == 0:
		trainer.items.remove_at(existing_item_index)
