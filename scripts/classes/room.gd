@icon("uid://cxowetj4sjjhk")
class_name Room extends Node2D
## Base class for creating rooms in GonerEngine's custom room system
## 
## When making a new room scene, set a [b]Room[/b] node as the root node.

@export var world_type: Global.WorldTypes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.world_type = world_type


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
