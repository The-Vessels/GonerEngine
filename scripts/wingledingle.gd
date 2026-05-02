extends AudioStreamPlayer

var time := 0.0

func _process(delta: float) -> void:
	pitch_scale = 4.0 + 1.0 * sin(2 * PI * time / 7.0)
	time += delta
