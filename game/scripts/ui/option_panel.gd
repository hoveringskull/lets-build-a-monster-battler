class_name OptionPanel extends Control

@export var mode: GameRunner.INTERACTION_MODE
@export var options_parent: Control

func populate(labels: Array[StringEnabled]):
	clear()

	for i in range(0, labels.size()):
		var index = i
		var option = labels[i].string
		var button = Button.new()
		options_parent.add_child(button)
		button.text = option
		button.disabled = !labels[i].enabled
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.pressed.connect(func(): Events.request_option_selected.emit(mode, index))

func clear():
	for child in options_parent.get_children():
		child.queue_free()
