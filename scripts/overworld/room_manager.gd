# Like the name implies, the RoomManager node handles
# everything related to our custom room logic.
# Room switching, player placement, etc.
extends Node2D

@onready var transition_player: AnimationPlayer = $"../TransitionLayer/TransitionPlayer"
@onready var world_camera: Camera2D = $"../WorldCamera"
@onready var menu_layer: CanvasLayer = $"../MenuLayer"

const PARTY_MEMBERS_SCENE = preload("uid://dw4u4k5xprkb0")

var pm_node: Node
var player: PartyMember

func _ready() -> void:
	Signals.changeRoom.connect(
		goto_room
	)
	Signals.warpParty.connect(
		warp_to_marker
	)
	
	var starting_room: Room = get_child(0)
	prepare_room(starting_room)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func goto_room(room):
	print("STARTING ROOM SWAP")
	# Find and remove the current room from the scene
	for child in get_children():
		child.queue_free()
	
	# Instantiate the new room to go to
	var room_instantiated: Room = room.instantiate()

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

func warp_to_marker(marker_id: int, facing: Enums.Facing) -> void:
	await Signals.room_change_finished
	for child in Global.currentRoom.find_children("*", "TargetMarkerDest"):
		if child.marker_id == marker_id:
			for pm in pm_node.get_children():
				var pos_adjusted = get_bottom_middle_tp_pos(pm, child)
				pm.position = pos_adjusted
				pm.facing = facing
	print("tped to marker")

func prepare_room(room: Room) -> void:
	# Get the necessary data from the new room to:
	print(room.scale)
	for child in room.get_children():
		# Set the camera limits provided in the new room
		if child is CameraBounds:
			world_camera.limit_left = child.tl_corner.x * room.scale.x
			world_camera.limit_top = child.tl_corner.y * room.scale.y
			world_camera.limit_right = child.br_corner.x * room.scale.x
			world_camera.limit_bottom = child.br_corner.y * room.scale.y
		# Create the party and teleport the player to the PlayerMarker
		if child is PlayerMarker:
			pm_node = PARTY_MEMBERS_SCENE.instantiate()
			player = pm_node.get_child(0)
			room.add_child(pm_node)
			
			for pm in pm_node.get_children():
				var pos_adjusted = get_bottom_middle_tp_pos(pm, child)
				pm.position = pos_adjusted
			
			world_camera.target = player
			print("tped to playermarker")

func get_bottom_middle_tp_pos(player: PartyMember, marker: Marker2D) -> Vector2:
	var sprite: AnimatedSprite2D = player.find_children("*", "AnimatedSprite2D")[0]
	var sprite_size: Vector2 =\
	sprite.sprite_frames.get_frame_texture(sprite.animation, 0).get_size()
	
	var adjusted_pos: Vector2 =\
	Vector2(marker.position.x - (sprite_size.x/2.0), marker.position.y - sprite_size.y)
	
	return adjusted_pos
