@icon("uid://cxowetj4sjjhk")
class_name Room extends Node2D
## Base class for creating rooms in GonerEngine's custom room system
## 
## When making a new room scene, set a [b]Room[/b] node as the root node.

@export var world_type: Global.WorldTypes

static func goto(room: String) -> void:
	Signals.changeRoom.emit(room)

static func warp_party(target_marker_id: int, player_facing: Enums.Facing) -> void:
	Signals.warpParty.emit(target_marker_id, player_facing)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.world_type = world_type


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
