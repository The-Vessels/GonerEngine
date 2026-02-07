extends Node2D

@export var texture_to_show: Texture2D

var mousepos: Vector2

func _process(_delta: float) -> void:
	mousepos = get_global_mouse_position()
	
	queue_redraw()

func _physics_process(_delta: float) -> void:
	var afterimage := Afterimage.new(0.5, 1.0, Vector2(100.0, 0.0))
	afterimage.texture = texture_to_show
	afterimage.global_position = mousepos
	afterimage.scale = Vector2(2.0, 2.0)
	add_child(afterimage)
