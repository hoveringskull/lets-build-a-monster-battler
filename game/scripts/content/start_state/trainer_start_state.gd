class_name TrainerStartState extends Resource

@export var name: String
@export var monsters: Array[MonsterStartState]
@export var items: Array[ItemStartState]

func generate_trainer(is_player: bool) -> Trainer:
	var generated_monsters: Array[Monster] = []
	for monster in monsters:
		generated_monsters.append(monster.generate())
			
	var trainer = TrainerController.create_trainer(generated_monsters, is_player)
	trainer.name = name
	
	for item in items:
		TrainerController.add_item(trainer, item.resource, item.quantity)
	
	return trainer
