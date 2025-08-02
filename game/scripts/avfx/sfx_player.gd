extends AudioStreamPlayer2D

func _ready():
	Events.on_avfx_sfx.connect(play_sfx)

func play_sfx(clip: AudioStream):
	stream = clip
	play()
