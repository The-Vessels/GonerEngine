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

func _enter_tree() -> void:
	add_to_group("room")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.world_type = world_type
	
	if get_parent() is Window:
		# This room is the root node.
		change_root_to_main()


func change_root_to_main() -> void:
	var main: Node = load("uid://d4byrh7pgiy13").instantiate()
	# get_parent().remove_child(self)
	get_parent().add_child.call_deferred(main)
	await get_tree().process_frame
	get_parent().remove_child(self)
	Signals.changeRoom.emit(self, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
