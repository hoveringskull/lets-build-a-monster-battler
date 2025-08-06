class_name MonsterRendererModule extends Control

# This is a UI panel that handles all visuals for a monster in the battle, 
# including its sprite, HPbar and name

@export 
var your_pov: bool

@export 
var frame: Control

@export
var data_panel: Control

@export
var name_label: Label

@export
var hp_label: Label

@export 
var hp_bar: ProgressBar

@export
var status_label: Label

@export
var sprite: Sprite2D

var bound_monster: Monster

func connect_events() -> void:
	Events.on_monster_updated.connect(maybe_update_monster)
	Events.on_monster_added_to_battle.connect(maybe_bind_monster)
	Events.on_avfx_flash_monster.connect(flash_monster)
	Events.on_avfx_move.connect(move_monster)

func maybe_update_monster(monster: Monster):
	if monster == bound_monster:
		update()

func maybe_bind_monster(monster: Monster, is_player_monster: bool):
	if your_pov == is_player_monster:
		bound_monster = monster
		move_child(frame, 0 if is_player_monster else 1)
		update()

func move_monster(avfx_instance: AVFXInstance, v2fs: Array[Vector2Float]):
	var avfx_target = avfx_instance.user if avfx_instance.resource.target_self else avfx_instance.target
	if avfx_target != bound_monster:
		avfx_instance.finish()
		return
	
	var tween = get_tree().create_tween()
	
	tween.tween_property(sprite, "offset", Vector2.ZERO, 0.0)\
		.set_delay(avfx_instance.resource.delay)
	
	for v2f in v2fs:
		var new_offset = v2f.v2 if your_pov else Vector2(-v2f.v2.x, v2f.v2.y)
		tween.tween_property(sprite, "offset", new_offset, v2f.f)
	
	tween.tween_property(sprite, "offset", Vector2.ZERO, 0.1)
	tween.tween_callback(avfx_instance.finish)

func flash_monster(avfx_instance: AVFXInstance, v2s: Array[Vector2]):
	var avfx_target = avfx_instance.user if avfx_instance.resource.target_self else avfx_instance.target
	if avfx_target != bound_monster:
		avfx_instance.finish()
		return
	
	var tween = get_tree().create_tween()

	tween.tween_property(sprite, "modulate", Color.WHITE, 0.0)\
		.set_delay(avfx_instance.resource.delay)
	
	for v2 in v2s:
		var color = Color(Color.WHITE, v2.x)
		tween.tween_property(sprite, "modulate", color, v2.y)
	
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.0)
	tween.tween_callback(avfx_instance.finish)

func update():
	if bound_monster == null:
		return
	
	name_label.text = bound_monster.name.to_upper()
	sprite.texture = bound_monster.image
	status_label.text = bound_monster.get_condition_string()
	hp_bar.max_value = bound_monster.max_hp
	animate_hp_bar(bound_monster.hp)
	hp_label.text = "{hp}\\{max_hp}".format({"hp": bound_monster.hp, "max_hp": bound_monster.max_hp})
	return

func animate_hp_bar(new_hp):
	var tween = get_tree().create_tween()
	tween.tween_property(hp_bar, "value", new_hp, 0.25)
