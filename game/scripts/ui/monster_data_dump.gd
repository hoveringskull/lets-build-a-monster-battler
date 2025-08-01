class_name MonsterDataDump extends Control

@export var label: Label
@export var your_monster: bool
var bound_monster: Monster

# The purpose of the class it to output a string representation of all relevant monster state,
# so we can see stats, conditions, etc. without having to go into code or write specialized
# UI handlers. Don't ship a game with something ugly like this.

func connect_events() -> void:
	Events.on_monster_updated.connect(maybe_update_monster)
	Events.on_monster_added_to_battle.connect(maybe_bind_monster)

func maybe_update_monster(monster: Monster):
	if monster == bound_monster:
		update()

func maybe_bind_monster(monster: Monster, is_player_monster: bool):
	if your_monster == is_player_monster:
		bound_monster = monster
		update()

func update():
	if bound_monster == null:
		return
	
	label.text = bound_monster.dump_state()
