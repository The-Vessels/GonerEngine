class_name Character extends CharacterBody2D
## A party member. May be a playable character.

@export var actor: Actor
@export var playable: bool

enum Facing {
	RIGHT,
	UP,
	LEFT,
	DOWN
}

enum AnimState {
	WALKRUN,
	NOWALK_ANIM,
	NOWALK_STALL,
	STOP
}

# FOR PLAYABLE CHARACTER
var running: bool
var runtimer: float = 0.0 # Frames since we started running
var time_since_walk: float
var facing: Facing = Facing.DOWN
var walking: bool = false
var last_walking: bool = false
var anim_state: float = 0.0
var walk_frame: int
var walk_progress: float

func _ready():
	$AnimatedSprite2D.sprite_frames = actor.animations
	$AnimatedSprite2D.play()

func _process(delta: float) -> void:
	var dtmult := delta * 30.0
	
	# Cancel is same button as sprint
	if Input.is_action_pressed("cancel"):
		running = true
		# I do this to prevent floating point precision error!
		if runtimer < 200.0:
			runtimer += dtmult
	else:
		running = false
		runtimer = 0.0
	
	var dir := get_walk_direction()
	walking = dir.x != 0.0 or dir.y != 0.0
	var walk_speed := 30.0 * get_walk_speed()

	velocity = walk_speed * dir
	move_and_slide()
	
	# TODO I need to make this animation logic better.
	
	if not facing_same(dir) and dir != Vector2.ZERO:
		facing = calc_facing_from_dir(dir)
	
	var speed_scale := 2.0 if running else 1.0
	if $AnimatedSprite2D.speed_scale != speed_scale:
		$AnimatedSprite2D.speed_scale = speed_scale
	
	var walk_anim := "walk_" + calc_animation_from_facing(facing)
	
	if walking and $AnimatedSprite2D.animation != walk_anim:
		play_animation_preserve(walk_anim)
	
	process_anim_state(dtmult)

func process_anim_state(dtmult: float):
	print(anim_state)
	if walking:
		anim_state = 8.0
	elif anim_state > 0.0:
		var last_anim_state = anim_state
		anim_state -= dtmult
		print('new anim_state: ', anim_state)
		
		if last_anim_state > 4.0 and anim_state <= 4.0:
			$AnimatedSprite2D.pause()
		elif last_anim_state > 0.0 and anim_state <= 0.0:
			var animation := "face_" + calc_animation_from_facing(facing)
			play_animation_face(animation)


func get_walk_direction() -> Vector2:
	var dir = Vector2.ZERO
	if Input.is_action_pressed('left'):
		dir.x = -1.0
	elif Input.is_action_pressed('right'):
		dir.x = 1.0
	if Input.is_action_pressed('up'):
		dir.y = -1.0
	elif Input.is_action_pressed('down'):
		dir.y = 1.0
	return dir

# Retrieves the walk speed (pixels per 30fps frame).
func get_walk_speed() -> int:
	var darkworld: bool = Global.world_type == Global.WorldTypes.WORLD_DARK
	
	var bwspeed := 4 if darkworld else 3
	
	if running:
		var add: int
		if runtimer > 60:
			add = 4
		elif runtimer > 10:
			add = 2
		else:
			add = 1
		
		var mul := 1.8 if darkworld else 1.0
		return bwspeed + round(add * mul)
		
	else:
		return bwspeed

func facing_same(dir: Vector2) -> bool:
	match facing:
		Facing.RIGHT:
			return dir.x == 1.0
		Facing.UP:
			return dir.y == -1.0
		Facing.LEFT:
			return dir.x == -1.0
		Facing.DOWN:
			return dir.y == 1.0
	return false

func calc_facing_from_dir(dir: Vector2) -> Facing:
	if dir.x == 1.0:
		return Facing.RIGHT
	if dir.y == 1.0:
		return Facing.DOWN
	if dir.x == -1.0:
		return Facing.LEFT
	if dir.y == -1.0:
		return Facing.UP
	
	assert(false)
	return Facing.DOWN

func calc_animation_from_facing(facing: Facing) -> String:
	match facing:
		Facing.RIGHT:
			return "right"
		Facing.UP:
			return "up"
		Facing.LEFT:
			return "left"
		Facing.DOWN:
			return "down"
	return ""

# Plays an animation, while preserving
# the frame and frame progress of the previous animation.
func play_animation_preserve(animation: StringName):
	var face := String(animation).begins_with("face_")
	var frame: int = walk_frame if face else $AnimatedSprite2D.frame
	var prog: float = walk_progress if face else $AnimatedSprite2D.frame_progress
	$AnimatedSprite2D.play(animation)
	$AnimatedSprite2D.frame = frame
	$AnimatedSprite2D.frame_progress = prog

func play_animation_load(animation: StringName):
	$AnimatedSprite2D.play(animation)
	$AnimatedSprite2D.frame = walk_frame
	$AnimatedSprite2D.frame_progress = walk_progress

func play_animation_face(animation: StringName):
	walk_frame = $AnimatedSprite2D.frame
	walk_progress = 1.0
	$AnimatedSprite2D.play(animation)
