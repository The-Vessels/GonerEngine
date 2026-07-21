extends Afterimage


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	opacity_rate = 0.04 * 30


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scale.y -= 0.1 * (delta * 30)
