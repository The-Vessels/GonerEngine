# Like the name implies, the RoomManager node handles
# everything related to our custom room logic.
# Room switching, player placement, etc.
extends Node2D

@onready var transition_player: AnimationPlayer = $"../TransitionLayer/TransitionPlayer"
@onready var player: Player = $Player
@onready var world_camera: Camera2D = $"../WorldCamera"

func _ready() -> void:
	Global.changeRoom.connect(
		func(room, target, facing):
			player.nopress = true
			transition_player.play("fade_to_black")
			await transition_player.animation_finished
			goto_room(room, target, facing)
			transition_player.play("fade_to_normal")
			player.nopress = false
	)
	for child in get_child(0).get_children():
			print(child.get_class())
			if child is CameraBounds:
				world_camera.limit_left = child.tl_corner.x
				world_camera.limit_top = child.tl_corner.y
				world_camera.limit_right = child.br_corner.x
				world_camera.limit_bottom = child.br_corner.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func goto_room(room, target, facing):
	var destination: TargetMarkerDest
	
	# Find and remove the current room from the scene
	var current_room: Room
	for child in get_children():
		if child is Room:
			current_room = child
			break
			
	if current_room:
		current_room.queue_free()
	else:
		print("There is no starting room in RoomManager")
		return
	
	var room_scene: PackedScene = load(room)
	var room_instantiated := room_scene.instantiate()
	
	add_child(room_instantiated)
	move_child(room_instantiated, 0)
	
	for child in room_instantiated.get_children():
		print(child.get_class())
		if child is CameraBounds:
			world_camera.limit_left = child.tl_corner.x
			world_camera.limit_top = child.tl_corner.y
			world_camera.limit_right = child.br_corner.x
			world_camera.limit_bottom = child.br_corner.y
		if child is TargetMarkerDest:
			if child.marker_id == target:
				destination = child
				player.position = destination.position
	player.facing = facing if facing else player.facing
