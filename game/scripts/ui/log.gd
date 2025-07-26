extends ScrollContainer

@export var content_container: Control

func _ready():
	Events.request_log.connect(log)
	

func log(text: String):
	var label = Label.new()
	label.text = text
	content_container.add_child(label)
	call_deferred("scroll_bottom")

func scroll_bottom():
	set_deferred("scroll_vertical", get_v_scroll_bar().max_value)


func clear():
	for child in get_children():
		child.queue_free()
