class_name MessagePanel extends Panel

@export var label: TypeoutLabel
@export var choice_parent: Control
@export var message_queue: Array[MessageResource] = []
@export var instance_queue: Array[AVFXInstance] = []

var current_message: MessageResource
var current_instance: AVFXInstance

func _ready():
	Events.on_avfx_messages.connect(queue_messages)

func _input(event):
	if current_message != null \
		and current_message.choices.size() == 0 \
		and event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_LEFT \
		and event.pressed:
			dismiss_message()

func queue_messages(instance: AVFXInstance):
	Events.on_message_panel_start.emit()
	if current_instance == null:
		run_instance(instance)
	else:
		instance_queue.append(instance)

func run_instance(instance: AVFXInstance):
	current_instance = instance
	message_queue = []
	for message in instance.resource.messages:
		message_queue.append(message)
		
	if current_message == null:
		show_message(message_queue.pop_front())

func dismiss_message():
	current_message = null
	if message_queue.size() == 0:
		if current_instance != null:
			current_instance.finish()
			current_instance = null
			
			if instance_queue.size() > 0:
				run_instance(instance_queue.pop_front())
			else:
				Events.on_message_panel_end.emit()
	else:
		show_message(message_queue.pop_front())

func show_message(message):
	current_message = message
	label.populate(message.text)
	
	for child in choice_parent.get_children():
		child.queue_free()
		
	for choice in message.choices:
		var button = Button.new()
		button.text = choice.name
		button.pressed.connect(func(): do_choice(choice.action))
		choice_parent.add_child(button)

func do_choice(action: Callable):
	dismiss_message()
	action.call()
	
