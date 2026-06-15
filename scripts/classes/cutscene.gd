class_name Cutscene

## Main cutscene function.
## Meant to be overridden.
func _run() -> void:
	pass

static func run(cutscene: Cutscene):
	await cutscene._run()

func get_actor(name: String) -> Actor:
	return Actor.get_by_name(name)

# CUTSCENE COMMANDS
func wait(n_frames: int):
	# I use the exact wait function
	# if n_frames is an integer or close to one.
	
	if n_frames - floor(n_frames) < 0.001:
		await wait_frames_exact(int(n_frames))
	else:
		await wait_seconds(n_frames / 30.0)

func wait_frames_exact(n_frames: int):
	while n_frames > 0:
		await Global.get_tree().physics_frame
		n_frames -= 1

func wait_seconds(seconds: float):
	await Global.get_tree().create_timer(seconds).timeout
