extends Control

@export var enemy_mon_module: MonsterRendererModule
@export var player_mon_module: MonsterRendererModule
@export var enemy_mon_state_dump: MonsterDataDump
@export var player_mon_state_dump: MonsterDataDump

func _ready():
	enemy_mon_module.connect_events()
	player_mon_module.connect_events()
	enemy_mon_state_dump.connect_events()
	player_mon_state_dump.connect_events()

	Events.on_avfx_projectile.connect(avfx_projectile)

	Events.on_ui_ready.emit()
		

func avfx_projectile(instance: AVFXInstance, texture: Texture2D):
	var sprite = Sprite2D.new()
	add_child(sprite)
	sprite.texture = texture
	
	sprite.global_position = player_mon_module.frame.global_position
	sprite.offset = instance.resource.offset
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "global_position", enemy_mon_module.frame.global_position, 0.5)
	tween.tween_callback(func(): cleanup_projectile(instance, sprite))
	return

func cleanup_projectile(instance, sprite):
	sprite.queue_free()
	instance.finish()
