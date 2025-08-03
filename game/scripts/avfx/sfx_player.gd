extends AudioStreamPlayer2D

func _ready():
	Events.on_avfx_sfx.connect(play_sfx)

func play_sfx(instance: AVFXInstance, clip: AudioStream):
	if instance.resource.delay == 0:
		do_play_sfx(instance, clip)
	else:
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = instance.resource.delay
		timer.one_shot = true
		timer.timeout.connect(func(): do_play_sfx(instance, clip))
		timer.start()
	
func do_play_sfx(instance: AVFXInstance, clip: AudioStream):
	pitch_scale = randf_range(0.9, 1.1)
	stream = clip
	finished.connect(instance.finish)
	play()
	
