class_name ChoiceResource extends Resource

@export var name: String
@export var action: Callable

func _init(nm: String, act: Callable):
	name = nm
	action = act
