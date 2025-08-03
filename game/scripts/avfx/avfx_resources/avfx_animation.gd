class_name AVFXAnimation extends AVFXResource

@export var animation_scene: PackedScene
@export var offset: Vector2 = Vector2(32, 32)

func _do(instance: AVFXInstance):
	Events.on_avfx_animation.emit(instance, animation_scene)
