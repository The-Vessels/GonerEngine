extends Node

## GonerEngine's own implementation of frame independent lerping.
## [br][br]
## The same as Godot's [method @GlobalScope.lerp], except [param weight] is frame independent
## [br][br]
## [b]Note:[/b] Actually uses dtmult (deltatime * 30) to be consistent with Deltarune's 30 FPS logic
func delta_lerp(from: Variant, to: Variant, weight: Variant) -> Variant:
	var dtmult = get_process_delta_time() * 30.0
	var lerp_vector = Vector2(pow(1.0 - weight, dtmult), pow(1.0 - weight, dtmult))
	var result = (from - to) * lerp_vector + to
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
