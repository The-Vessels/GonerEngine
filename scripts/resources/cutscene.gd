# This is not a Resource but IDK where else to put it
class_name Cutscene extends Node
## Inherit from Cutscene to make a new cutscene.

# Waits for some amount of 30FPS frames to pass.
func wait_frames(n_frames: int):
	while n_frames > 0:
		await get_tree().physics_frame
		n_frames -= 1
