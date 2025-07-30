extends Node

# The main script that controls the flow of the game.

# INTERACTION_MODE encodes the menu states the main battle menu can be in.
# Since RUN isn't a special menu, it does not get an entry here
enum INTERACTION_MODE {NONE, FIGHT, ITEM, MON}

func _ready():
	# Connect signal listeners
	Events.request_menu_fight.connect(handle_request_menu_fight)
	
	
func handle_request_menu_fight():
	var labels: Array[StringEnabled] = [StringEnabled.new("A", true), StringEnabled.new("B", false)]
	Events.on_menu_fight.emit(labels)
