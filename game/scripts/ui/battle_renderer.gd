extends Control

@export var enemy_mon_module: MonsterRendererModule
@export var player_mon_module: MonsterRendererModule
@export var enemy_mon_state_dump: MonsterDataDump
@export var player_mon_state_dump: MonsterDataDump

func _ready():
	enemy_mon_module.connect_events()
	player_mon_module.connect_events()
	
	Events.on_ui_ready.emit()
		
