@icon("uid://hhm251yn12yd")
class_name CameraBounds extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var tl_corner: Vector2
var br_corner: Vector2
var rect: Rect2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rect = collision_shape_2d.shape.get_rect()
	
	tl_corner = rect.position + (rect.size / 2)
	br_corner = rect.end + (rect.size / 2)
	
	print(tl_corner)
	print(br_corner)
