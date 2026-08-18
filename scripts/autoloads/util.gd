extends Node

## GonerEngine's own implementation of frame independent lerping.
## [br][br]
## The same as Godot's [method @GlobalScope.lerp], except [param weight] is frame independent
## [br][br]
## [b]Note:[/b] Actually uses dtmult (deltatime * 30) to be consistent with Deltarune's 30 FPS logic
func delta_lerp(from: Variant, to: Variant, weight: Variant) -> Variant:
	assert(typeof(from) == typeof(to), "Parameters 'from' and 'to' must be of the same type.")
	assert(weight is float or weight is int, "'weight' must be a float or int")
	
	var dtmult = get_process_delta_time() * 30.0
	var result = (from - to) * pow(1.0 - weight, dtmult) + to
	return result

## Converts seconds to physics frames (1/30th of a second)
## [codeblock]
## Util.sec_to_frames(2.5) #returns 75.0
## [/codeblock]
func sec_to_frames(seconds: float) -> float:
	return seconds * 30.0

## Converts physics frames (1/30th of a second) to seconds
## [codeblock]
## Util.frames_to_sec(75.0) #returns 2.5
## [/codeblock]
func frames_to_sec(frames: float) -> float:
	return frames / 30.0

## Explode a Node2D
func explode(node: Node2D, scale: Variant = Vector2(1.0, 1.0), speed: float = 1.0, volume_scale: float = 1.0, offset: Vector2 = Vector2.ZERO) -> void:
	var explode_node = AnimatedSprite2D.new()
	explode_node.name = "RealisticExplosion"
	explode_node.sprite_frames = load("res://sprites/misc/realistic_explosion/realistic_explosion.tres")
	explode_node.speed_scale = speed
	explode_node.y_sort_enabled = true
	
	if scale is Vector2 or scale is float or scale is int:
		if !(scale is Vector2):
			scale = Vector2(scale, scale)
		explode_node.scale = scale
	else:
		push_error(
			"Type '{type}' is not supported for explode scale. Supported types: float, int, Vector2"
				.format({"type": type_string(typeof(scale))})
		)
		explode_node.scale = Vector2(1.0, 1.0)
	
	
	Global.currentRoom.add_child(explode_node)
	explode_node.global_position = node.global_position + offset
	
	node.queue_free()
	explode_node.play()
	Global.play_sound("misc/snd_badexplosion", volume_scale)
	
	await explode_node.animation_finished
	explode_node.queue_free()
