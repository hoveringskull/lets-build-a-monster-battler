class_name AVFXResource extends Resource

@export var target_self: bool
@export var delay: float

func _do(instance: AVFXInstance):
	return

func generate(target: Monster, user: Monster) -> AVFXInstance:
	return AVFXInstance.new(self, target, user)
