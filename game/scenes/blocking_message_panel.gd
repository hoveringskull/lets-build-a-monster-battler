class_name BlockingMessagePanel extends Panel

@export var label: TypeoutLabel
@export var message_queue: Array[String] = []
@export var instance_queue: Array[AVFXInstance] = []

var current_message: String = ""
var current_instance: AVFXInstance

func _ready():
	Events.on_avfx_queue_messages.connect(queue_messages)

func _input(event):
	if current_message != "" and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			dismiss_message()
			

func queue_messages(instance: AVFXInstance, messages: Array[String]):
	start_block()
	if current_instance == null:
		run_instance(instance)
	else:
		instance_queue.append(instance)

func run_instance(instance: AVFXInstance):
	current_instance = instance
	message_queue = []
	for message in instance.resource.messages:
		message_queue.append(message)
	
	if current_message == "":
		show_message(message_queue.pop_front())

func start_block():
	Events.on_message_panel_block_start.emit()

func dismiss_message():
	current_message = ""
	if message_queue.size() == 0:
		if current_instance != null:
			current_instance.finish()
			current_instance = null
			
			if instance_queue.size():
				var instance: AVFXInstance = instance_queue.pop_front()
				run_instance(instance)
	
		Events.on_message_panel_block_end.emit()
	else:
		show_message(message_queue.pop_front())

func show_message(message):
	current_message = message
	label.populate(message)
	
