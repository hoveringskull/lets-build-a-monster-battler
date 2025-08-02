class_name AVFXPlaySFX extends AVFXResource

@export var clip: AudioStream

func _do(instance: AVFXInstance):
	Events.on_avfx_sfx.emit(clip)
