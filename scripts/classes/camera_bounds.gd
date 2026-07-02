@icon("uid://hhm251yn12yd")
class_name CameraBounds extends Area2D
## An Area2D for dynamically setting the limits of the WorldCamera for a room.
## 
## Place in a [Room] to set the limits for the game's main camera for that room.
## [br][br]
## [b]Note:[/b] It is recommended to place this at/near the start of the room's SceneTree
## so that it stays out of the way.

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var tl_corner: Vector2
var br_corner: Vector2
var rect: Rect2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rect = collision_shape_2d.shape.get_rect()
	
	tl_corner = rect.position + (rect.size / 2)
	br_corner = rect.end + (rect.size / 2)
