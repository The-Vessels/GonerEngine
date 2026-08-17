@icon("uid://4nggui1prwda")
class_name TeleportArea extends Area2D
## An Area2D for teleporting to another room.
##
## [b]Note:[/b] Use with [TargetMarkerDest] to set destination position of the player

# Room to teleport to
@export_file("*.tscn") var target_scene: String
# ID of the TargetMarkerDest to position the player at
@export var target_marker_id: int
@export var player_facing: Enums.Facing = Enums.Facing.DOWN
# https://www.desmos.com/calculator/zis855e0vt
@export var frames_length: float = 12.5

#@onready var scene_container: Node = get_tree().root.get_child(-1).get_node("RoomManager")

func _ready():
	body_entered.connect(_on_body_entered)
	#print('HIIIIII ', scene_container)

func _on_body_entered(body: Node2D) -> void:
	# Don't do anything if the body entered isn't the player
	if !(body is PartyMember and body.is_playable()):
		return
	
	Global.moveable = false
	await Global.fader_fade(0.0, 1.0, frames_length)
	
	Room.goto(load(target_scene))
	Room.warp_party(target_marker_id, player_facing)
	
	Global.fader_fade(1.0, 0.0, frames_length)
	Global.moveable = true
