class_name Afterimage extends Sprite2D

var opacity_rate: float
var velocity: Vector2

func _init(starting_opacity: float, time_until_delete: float, vel: Vector2 = Vector2.ZERO):
	# texture = tex
	z_as_relative = true
	z_index = -1
	
	modulate.a = starting_opacity
	opacity_rate = starting_opacity / time_until_delete
	velocity = vel

func _process(delta: float) -> void:
	position += velocity * delta
	modulate.a -= opacity_rate * delta
	#modulate -= Color(1.25, 1.25, 1.25, 0.0) * delta
	if modulate.a <= 0.0:
		queue_free()
