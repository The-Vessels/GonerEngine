# Like the name implies, the RoomManager node handles
# everything related to our custom room logic.
# Room switching, player placement, etc.
extends Node2D

@onready var transition_player: AnimationPlayer = $"../TransitionLayer/TransitionPlayer"
@onready var world_camera: Camera2D = $"../WorldCamera"
@onready var menu_layer: CanvasLayer = $"../MenuLayer"

const PARTY_MEMBERS_SCENE = preload("uid://dw4u4k5xprkb0")

var pm_node: Node
var player: Node

func _ready() -> void:
	Signals.changeRoom.connect(
		goto_room
	)
	Signals.warpParty.connect(
		warp_to_marker
	)
	
	var starting_room = get_child(0)
	prepare_room(starting_room)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func goto_room(room):
	print("STARTING ROOM SWAP")
	# Find and remove the current room from the scene
	for child in get_children():
		child.queue_free()
	
	# Fetch and instantiate the new room to go to
	var room_scene: PackedScene = load(room)
	var room_instantiated: Room = room_scene.instantiate()

	# Add the correct menu for the new room's world type
	menu_layer.get_child(0).queue_free()
	match room_instantiated.world_type:
		Global.WorldTypes.WORLD_LIGHT:
			var menu_scene: PackedScene = load("res://scenes/ui/light_menu.tscn")
			menu_layer.add_child(menu_scene.instantiate())
		Global.WorldTypes.WORLD_DARK:
			var menu_scene: PackedScene = load("res://scenes/ui/dark_menu.tscn")
			menu_layer.add_child(menu_scene.instantiate())
	
	add_child(room_instantiated)
	Global.currentRoom = room_instantiated
	
	prepare_room(room_instantiated)
	
	Signals.room_change_finished.emit()
	print("FINISHED ROOM SWAP")

func warp_to_marker(marker_id, facing):
	await Signals.room_change_finished
	for child in Global.currentRoom.get_children():
		if child is TargetMarkerDest:
			if child.marker_id == marker_id:
				player.position = child.position
				player.facing = facing
	print("tped to marker")

func prepare_room(room):
	# Get the necessary data from the new room to:
	for child in room.get_children():
		# Set the camera limits provided in the new room
		if child is CameraBounds:
			world_camera.limit_left = child.tl_corner.x
			world_camera.limit_top = child.tl_corner.y
			world_camera.limit_right = child.br_corner.x
			world_camera.limit_bottom = child.br_corner.y
		# Create the party and teleport the player to the PlayerMarker
		if child is PlayerMarker:
			pm_node = PARTY_MEMBERS_SCENE.instantiate()
			player = pm_node.get_child(0)
			room.add_child(pm_node)
			player.position = child.position
			print("tped to playermarker")
			world_camera.target = player
