extends Node2D

@export var texture_to_show: Texture2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var mousepos: Vector2
var slowerer := 1

func _process(_delta: float) -> void:
	mousepos = get_global_mouse_position()
	
	queue_redraw()

func _physics_process(delta: float) -> void:
	slowerer += 1
	sprite_2d.texture = texture_to_show
	sprite_2d.global_position = Vector2(167, 169)
	sprite_2d.global_position.y += 10 * sin(slowerer * 0.1275)
	sprite_2d.scale = Vector2(2.0, 2.0)
	# tried to get it as accurate to the knight as i could lol
	var afterimage := Afterimage.new(0.5, 0.65, Vector2(75.0, 0.0))
	afterimage.texture = texture_to_show
	afterimage.global_position = sprite_2d.global_position
	afterimage.scale = Vector2(2.0, 2.0)
	if slowerer % 3 == 0:
		add_child(afterimage)
		#sprite_2d.global_position += Vector2(randf_range(0, 2), randf_range(0, 2))
