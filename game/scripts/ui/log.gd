extends ScrollContainer

@export var content_container: Control

func _ready():
	# Connect signal listeners
	Events.request_log.connect(log)
	

func log(text: String):
	# Log simply spawns a new label in the log and scrolls to it. Great for seeing what's happening.
	var label = Label.new()
	label.text = text
	content_container.add_child(label)
	call_deferred("scroll_bottom")

func scroll_bottom():
	set_deferred("scroll_vertical", get_v_scroll_bar().max_value)


func clear():
	for child in get_children():
		child.queue_free()
