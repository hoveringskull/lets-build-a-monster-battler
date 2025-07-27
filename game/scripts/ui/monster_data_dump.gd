class_name MonsterDataDump extends Control

@export var label: Label

# The purpose of the class it to output a string representation of all relevant monster state,
# so we can see stats, conditions, etc. without having to go into code or write specialized
# UI handlers. Don't ship a game with something ugly like this.

func _ready():
	# TODO: Listen for changes to the monsters
	return
	
func update(_monster):
	# TODO check if the changes are to the current monster, and update if so
	return
