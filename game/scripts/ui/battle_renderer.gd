extends Control

@export var enemy_mon_module: MonsterRendererModule
@export var player_mon_module: MonsterRendererModule
@export var enemy_mon_state_dump: MonsterDataDump
@export var player_mon_state_dump: MonsterDataDump
@export var message_panel: BlockingMessagePanel
@export var control_panel: Control

func _ready():
	enemy_mon_module.connect_events()
	player_mon_module.connect_events()
	enemy_mon_state_dump.connect_events()
	player_mon_state_dump.connect_events()

	Events.on_avfx_projectile.connect(avfx_projectile)
	Events.on_avfx_animation.connect(avfx_animation)
	Events.on_avfx_flash_screen.connect(avfx_flash_screen)
	Events.on_avfx_shake_screen.connect(avfx_shake_screen)
	Events.on_message_panel_block_end.connect(hide_message_panel)
	Events.on_message_panel_block_start.connect(show_message_panel)
	Events.on_ui_ready.emit()
	
	message_panel.hide()
		

func avfx_flash_screen(avfx_instance: AVFXInstance, v2s: Array[Vector2]):
	var tween = get_tree().create_tween()

	tween.tween_property(self, "modulate", Color.WHITE, 0.0)\
		.set_delay(avfx_instance.resource.delay)
	
	for v2 in v2s:
		var color = Color(Color.WHITE, v2.x)
		tween.tween_property(self, "modulate", color, v2.y)
	
	tween.tween_property(self, "modulate", Color.WHITE, 0.0)
	tween.tween_callback(avfx_instance.finish)
	
func avfx_shake_screen(avfx_instance: AVFXInstance, v3s: Array[Vector3]):
	var tween = get_tree().create_tween()

	tween.tween_property(self, "position", Vector2.ZERO, 0.0)\
		.set_delay(avfx_instance.resource.delay)
	
	for v3 in v3s:
		var v2 = Vector2(v3.x, v3.y)
		tween.tween_property(self, "position", v2, v3.z)
	
	tween.tween_property(self, "position", Vector2.ZERO, 0.0)
	tween.tween_callback(avfx_instance.finish)

func avfx_projectile(instance: AVFXInstance, texture: Texture2D):
	if instance.resource.delay == 0:
		do_avfx_projectile(instance, texture)
	else:
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = instance.resource.delay
		timer.one_shot = true
		timer.timeout.connect(func(): do_avfx_projectile(instance, texture))
		timer.start()

func do_avfx_projectile(instance: AVFXInstance, texture: Texture2D):
	var frame_start = get_monster_frame(instance.target if instance.resource.target_self else instance.user)
	var frame_end = get_monster_frame(instance.user if instance.resource.target_self else instance.target)
	if frame_start == null or frame_end == null:
		print("Missing frame for projectile!")
		instance.finish()
		return
	
	var sprite = Sprite2D.new()
	add_child(sprite)
	sprite.texture = texture
	
	sprite.global_position = frame_start.global_position
	sprite.offset = instance.resource.offset
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "global_position", frame_end.global_position, instance.resource.duration)
	tween.tween_callback(func(): cleanup_avfx_node(instance, sprite))
	
func avfx_animation(instance: AVFXInstance, animation_scene: PackedScene):
	if instance.resource.delay == 0:
		do_avfx_animation(instance, animation_scene)
	else:
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = instance.resource.delay
		timer.one_shot = true
		timer.timeout.connect(func(): do_avfx_animation(instance, animation_scene))
		timer.start()

	
func do_avfx_animation(instance: AVFXInstance, animation_scene: PackedScene):
	var frame_target = get_monster_frame(instance.user if instance.resource.target_self else instance.target)
	if frame_target == null:
		print("Missing frame for animation!")
		instance.finish()
		return
	var animation_node: AnimatedSprite2D = animation_scene.instantiate()
	add_child(animation_node)
	animation_node.global_position = frame_target.global_position
	animation_node.sprite_frames.set_animation_loop("default", false)
	animation_node.offset = instance.resource.offset
	animation_node.play()
	animation_node.animation_finished.connect(func(): cleanup_avfx_node(instance, animation_node))

func get_monster_frame(monster: Monster):
	if enemy_mon_module.bound_monster == monster:
		return enemy_mon_module.frame
	if player_mon_module.bound_monster == monster:
		return player_mon_module.frame
	return null

func cleanup_avfx_node(instance, node):
	node.queue_free()
	instance.finish()

func hide_message_panel():
	message_panel.hide()
	control_panel.show()
	
func show_message_panel():
	message_panel.show()
	control_panel.hide()
