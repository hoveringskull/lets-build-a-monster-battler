extends Node

enum INTERACTION_MODE {NONE, FIGHT, ITEM, MON}

func _ready():
	Events.request_menu_fight.connect(handle_request_menu_fight)
	
	
func handle_request_menu_fight():
	var labels: Array[StringEnabled] = [StringEnabled.new("A", true), StringEnabled.new("B", false)]
	Events.on_menu_fight.emit(labels)
