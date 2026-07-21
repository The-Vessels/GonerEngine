extends Afterimage
var direction:float = 0
var c:Vector2 = Vector2(0,0)
var target:Vector2 = Vector2(0,0)



@export var texture_to_show: Texture2D
@onready var sprite_2d: Sprite2D = $Sprite2D



func _process(_delta: float) -> void:

	
	queue_redraw()

func _physics_process(_delta: float) -> void:
	

	sprite_2d.scale = Vector2(2.0, 2.0)
	# tried to get it as accurate to the knight as i could lol
	var afterimage := Afterimage.new(0.5, 0.65, Vector2(75.0, 0.0))

		#sprite_2d.global_position += Vector2(randf_range(0, 2), randf_range(0, 2))

	#if modulate.a < 1:
		#modulate.a += 0.25 * (delta * 30)
