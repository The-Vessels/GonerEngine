extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.changeMusic.connect(
		func(music, pitch):
			set_music(music, pitch)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_music(music, pitch):
	stream = music
	pitch_scale = pitch
	playing = true
