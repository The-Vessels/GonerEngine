extends AudioStreamPlayer

var mus_tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.changeMusic.connect(
		set_music
	)
	Signals.fadeMusic.connect(
		fade_music
	)

func set_music(music, gain, pitch):
	if mus_tween and mus_tween.is_running():
		mus_tween.kill()
	stream = music
	volume_linear = gain
	pitch_scale = pitch
	play()

func fade_music(gain, duration):
	mus_tween = create_tween()
	mus_tween.tween_property(self, "volume_linear", gain, (duration / 30.0))
