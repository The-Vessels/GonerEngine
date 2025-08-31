extends Node2D
@onready var char = $BorderRect
var open = false
func _process(delta: float) -> void:
	char.position.y = lerp(char.position.y,252.0 if not open else 216.0,0.2)
	if Input.is_action_just_pressed("down"):
		open = !open
