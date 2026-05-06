extends Node2D
@onready var room_manager: Node2D = $"."
@onready var transition_player: AnimationPlayer = $"../TransitionScreen/AnimationPlayer"
@onready var player: CharacterBody2D = $"../Player"
@onready var camera_2d: Camera2D = $"../Camera2D"

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
				camera_2d.limit_left = child.tl_corner.x
				camera_2d.limit_top = child.tl_corner.y
				camera_2d.limit_right = child.br_corner.x
				camera_2d.limit_bottom = child.br_corner.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func goto_room(room, target, facing):
	var facing_dir = facing
	var target_marker: TargetMarker
	print(facing_dir)
	
	if room_manager.get_child_count() == 1:
		var ch = room_manager.get_child(0)
		ch.queue_free()
		
		var scene: PackedScene = load(room)
		var instantiated := scene.instantiate()
		
		room_manager.add_child(instantiated)
		
		for child in instantiated.get_children():
			print(child.get_class())
			if child is CameraBounds:
				camera_2d.limit_left = child.tl_corner.x
				camera_2d.limit_top = child.tl_corner.y
				camera_2d.limit_right = child.br_corner.x
				camera_2d.limit_bottom = child.br_corner.y
			if child is TargetMarker:
				if child.marker_id == target:
					target_marker = child
					player.position = target_marker.position
		player.facing = facing if facing else player.facing
