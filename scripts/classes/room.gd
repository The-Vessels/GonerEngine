@icon("uid://cxowetj4sjjhk")
class_name Room extends Node2D
## Base class for creating rooms in GonerEngine's custom room system
## 
## When making a new room scene, set a [b]Room[/b] node as the root node.

@export var world_type: Global.WorldTypes

## Change the room to a specified loaded [param room] resource
## [codeblock]
## Room.goto(load("res://scenes/overworld/rooms/hometown.tscn"))
## [/codeblock]
static func goto(room: PackedScene) -> void:
	Signals.changeRoom.emit(room)

## Set all your [PartyMember]'s positions to a [TargetMarkerDest] with a given [param target_marker_id]
## and set their [param facing] directions.
## [codeblock]
## Room.warp_party(1, Enums.Facing.LEFT)
## [/codeblock]
static func warp_party(target_marker_id: int, facing: Enums.Facing) -> void:
	Signals.warpParty.emit(target_marker_id, facing)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.world_type = world_type


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
