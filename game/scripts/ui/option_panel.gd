class_name OptionPanel extends Control

# Option panels present a box with some number of player options. We use it here
# to choose moves, monsters and items.

@export var mode: GameRunner.INTERACTION_MODE
@export var options_parent: Control

func populate(labels: Array[StringEnabled]):
	# Clear out all old state.
	clear()

	for i in range(0, labels.size()):
		# Create each button...
		var index = i
		var option = labels[i].string
		var button = Button.new()
		options_parent.add_child(button)
		button.text = option
		button.disabled = !labels[i].enabled
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		# ... and bind a listener to it to send a request. This will be listened-for in game_runner.gd
		button.pressed.connect(func(): Events.request_option_selected.emit(mode, index))

func clear():
	# Clear all buttons. Note that signal listeners will be cleaned up on queue_free
	for child in options_parent.get_children():
		child.queue_free()
