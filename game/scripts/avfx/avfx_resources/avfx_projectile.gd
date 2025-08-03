class_name AVFXProjectile extends AVFXResource

@export var sprite: Texture2D
@export var offset: Vector2 = Vector2(32,32)
@export var duration: float = 0.5

func _do(instance: AVFXInstance):
	Events.on_avfx_projectile.emit(instance, sprite)
