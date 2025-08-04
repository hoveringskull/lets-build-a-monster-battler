extends Node

var active_effect_count: int
var effect_group_queue: Array[Node]
var current_effect_group: Node
var active: bool
var timeout_timer: Timer

const MAX_GROUP_TIMEOUT: float = 6.0

func _ready():
	timeout_timer = Timer.new()
	add_child(timeout_timer)
	timeout_timer.wait_time = MAX_GROUP_TIMEOUT
	timeout_timer.timeout.connect(timeout_current_group)
	timeout_timer.one_shot = true
	
	Events.on_message_panel_block_start.connect(func(): timeout_timer.paused = true)
	Events.on_message_panel_block_end.connect(func(): timeout_timer.paused = false)

func _process(_delta: float) -> void:
	if active and current_effect_group == null:
		if effect_group_queue.size() == 0:
			timeout_timer.stop()
			Events.on_avfx_block_end.emit()
			active = false
		else:
			timeout_timer.start()
			current_effect_group = effect_group_queue.pop_front()
			active_effect_count = current_effect_group.get_children().size()
			for avfx_instance in current_effect_group.get_children():
				avfx_instance.execute()
			call_deferred("emit_block_start")

func queue_avfx_message_group(messages: Array[String]):
	var avfx_messages = AVFXMessages.new(messages)
	queue_avfx_effect_group([avfx_messages], null)
	
func queue_avfx_message(message: String):
	var avfx_messages = AVFXMessages.new([message] as Array[String])
	queue_avfx_effect_group([avfx_messages], null)

func queue_avfx_effect_group(resources: Array[AVFXResource], monster: Monster):
	active = true
	var group = Node.new()
	add_child(group)
	for resource in resources:
		if resource == null:
			continue
		var target = MonsterController.get_monster_opponent(monster)
		var instance = resource.generate(target, monster)
		group.add_child(instance)
		instance.name = resource.get_script().get_global_name()
	
	if group.get_children().size() > 0:
		effect_group_queue.append(group)
	else:
		group.queue_free()

func emit_block_start():
	Events.on_avfx_block_start.emit()

func remove_effect(avfx_instance: AVFXInstance):
	avfx_instance.queue_free()
	active_effect_count -= 1
	
	if active_effect_count == 0:
		current_effect_group.queue_free()
		current_effect_group = null
		
func timeout_current_group():
	if current_effect_group == null:
		return
	
	print("Timed out effect " + current_effect_group.name)
	
	for child in current_effect_group.get_children():
		if child.has_method("finish"):
			child.finish()
	
	if current_effect_group != null:
		current_effect_group.queue_free()	
		current_effect_group = null
