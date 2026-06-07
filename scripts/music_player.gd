extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.changeMusic.connect(
		set_music
	)

func set_music(music, pitch):
	stream = music
	pitch_scale = pitch
	play()
