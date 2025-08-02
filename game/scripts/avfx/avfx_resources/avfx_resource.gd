class_name AVFXResource extends Resource

@export var target_self: bool

func _do(instance: AVFXInstance):
	return

func generate(target: Monster) -> AVFXInstance:
	return AVFXInstance.new(self, target)
