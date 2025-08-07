class_name ChoiceResource extends Resource

@export var text: String
@export var function: Callable

func _init(txt: String, fn: Callable):
	text = txt
	function = fn
