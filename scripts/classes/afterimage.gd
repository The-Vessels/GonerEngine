class_name Afterimage extends Sprite2D

const default_fade_rate := 0.04*30.0

var opacity_rate: float
var velocity: Vector2

static func with_fade_time(fade_time: float, starting_opacity: float = 1.0, vel: Vector2 = Vector2.ZERO) -> Afterimage:
	var fade_rate: float
	fade_rate = starting_opacity / (fade_time / 30.0)
	return new(fade_rate, starting_opacity, vel)

func _init(fade_rate: float = default_fade_rate, starting_opacity: float = 1.0, vel: Vector2 = Vector2.ZERO):
	# texture = tex
	z_as_relative = true
	z_index = -1
	
	modulate.a = starting_opacity
	opacity_rate = fade_rate
	velocity = vel

func _process(delta: float) -> void:
	position += velocity * delta
	modulate.a -= opacity_rate * delta
	#modulate -= Color(1.25, 1.25, 1.25, 0.0) * delta
	if modulate.a <= 0.0:
		queue_free()

func duplicate_node(node: Node2D):
	node.position = self.position
	print(node)
	self.add_child(node)
	print(get_children())
