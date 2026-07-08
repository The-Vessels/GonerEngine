class_name PartyMember extends Actor
## A party member. May be a playable character.

static var party_list: Array[PartyMember] = [null, null, null]

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
var facing: Enums.Facing = Enums.Facing.DOWN
var walking: bool = false
var anim_state: float = 0.0
var walk_frame: int
var walk_progress: float

var follow_target := 12

# Can this party member move independently from being an actor?
# var can_move: bool = true

# Stores last positions, only for main character
var last_positions: CircularQueue

#TODO we HAVE to figure out better party logic here
func _enter_tree() -> void:
	# print("CHARACTER " + chara.name + " ENTERED")
	super._enter_tree()
	party_list[get_index()] = self
	process_priority = get_index()
	
func _exit_tree() -> void:
	# print("CHARACTER " + chara.name + " EXITED")
	super._exit_tree()
	if party_list[get_index()] == self:
		party_list[get_index()] = null

func is_playable() -> bool:
	return get_index() == 0

func _ready():
	super._ready()
	
	if is_playable():
		last_positions = CircularQueue.new(100)
	else:
		collision_layer = 0 # Do not collide!

func _process(delta: float) -> void:
	if Global.moveable:
		party_member_process(delta)

func _physics_process(_delta: float) -> void:
	if Global.moveable and is_playable():
		if Input.is_action_just_pressed("confirm"):
			do_interact()
		if Input.is_action_just_pressed('menu'):
			Signals.toggleMenu.emit()

func party_member_process(delta: float) -> void:
	var dtmult := delta * 30.0
	
	if is_playable():
		move_playable_character(dtmult)
		#if Input.is_action_just_pressed("confirm"):
			#do_interact()
	else:
		follow_main_character()
	
	# TODO I need to make this animation logic better.
	var speed_scale := 2.0 if running else 1.0
	if $AnimatedSprite2D.speed_scale != speed_scale:
		$AnimatedSprite2D.speed_scale = speed_scale
	
	var anim_suffix := calc_animation_from_facing(facing)
	if walking:
		play_animation_preserve("walk_" + anim_suffix)
	#if not walking and $AnimatedSprite2D.animation != "face_" + anim_suffix:
		#play_animation_preserve("face_" + anim_suffix)
	
	process_anim_state(dtmult)

# I made this a function because I thought it might get more
# involved.
# For example, if Susie is far away from Kris at the start,
# moving will cause her to teleport near to Kris, with this logic,
# and I'm wondering if that is okay or not.
func follow_main_character():
	var leader := party_list[0]
	# if leader == null:
	# 	return

	var info: CaterpillarInfo = leader.last_positions.get_val(follow_target)
	if info == null:
		return
	var main_last_frame_info: CaterpillarInfo = leader.last_positions.get_val(1)
	
	walking = leader.position != main_last_frame_info.pos
	
	if walking:
		position = info.pos
		facing = info.facing
		
		var run_thresh := 4.0 if Global.is_dark() else 8.0
		var follower_last_frame_info: CaterpillarInfo = \
			leader.last_positions.get_val(follow_target + 1)
		var pos_diff := (follower_last_frame_info.pos - info.pos).abs()
		running = (pos_diff.x > run_thresh) or (pos_diff.y > run_thresh)
	
	#walking = leader.walking
	#running = leader.running

func move_playable_character(dtmult: float):
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
	var old_walking := walking
	walking = dir.x != 0.0 or dir.y != 0.0
	var walk_speed := 30.0 * get_walk_speed()

	velocity = walk_speed * dir
	move_and_slide()
	
	if old_walking:
		var info := CaterpillarInfo.new(position, facing, walking, running)
		last_positions.add(info)
	
	if not facing_same(dir) and dir != Vector2.ZERO:
		facing = calc_facing_from_dir(dir)


func process_anim_state(dtmult: float):
	# print(anim_state)
	if walking:
		anim_state = 8.0
		# walk_frame = $AnimatedSprite2D.frame
		# walk_progress = $AnimatedSprite2D.frame_progress
	elif anim_state > 0.0:
		var last_anim_state = anim_state
		anim_state -= dtmult
		# print('new anim_state: ', anim_state)
		
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
	var bwspeed := 4 if Global.is_dark() else 6
	
	if running:
		var add: int
		if runtimer > 60:
			add = 4
		elif runtimer > 10:
			add = 2
		else:
			add = 1
		
		var mul := 1.8 if Global.is_dark() else 1.0
		return bwspeed + round(add * mul)
		
	else:
		return bwspeed

func facing_same(dir: Vector2) -> bool:
	match facing:
		Enums.Facing.RIGHT:
			return dir.x == 1.0
		Enums.Facing.UP:
			return dir.y == -1.0
		Enums.Facing.LEFT:
			return dir.x == -1.0
		Enums.Facing.DOWN:
			return dir.y == 1.0
	return false

func calc_facing_from_dir(dir: Vector2) -> Enums.Facing:
	if dir.x == 1.0:
		return Enums.Facing.RIGHT
	if dir.y == 1.0:
		return Enums.Facing.DOWN
	if dir.x == -1.0:
		return Enums.Facing.LEFT
	if dir.y == -1.0:
		return Enums.Facing.UP
	
	assert(false)
	return Enums.Facing.DOWN

func calc_animation_from_facing(facing: Enums.Facing) -> String:
	match facing:
		Enums.Facing.RIGHT:
			return "right"
		Enums.Facing.UP:
			return "up"
		Enums.Facing.LEFT:
			return "left"
		Enums.Facing.DOWN:
			return "down"
	return ""

func do_interact():
	var shape_cast: ShapeCast2D = get_node("ShapeCast2D")
	shape_cast.target_position = 15.0 * Enums.facing_to_vec(facing)
	shape_cast.force_shapecast_update()
	if shape_cast.is_colliding():
		for i in range(shape_cast.get_collision_count()):
			var collided_node: Node = shape_cast.get_collider(i)
			if collided_node.has_method("interact"):
				collided_node.interact()
				break
	shape_cast.target_position = Vector2(0.0, 0.0)

# Plays an animation, while preserving
# the frame and frame progress of the previous animation.
func play_animation_preserve(animation: StringName):
	if $AnimatedSprite2D.animation == animation and $AnimatedSprite2D.is_playing():
		return
	
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

class CaterpillarInfo:
	var pos: Vector2
	var facing: Enums.Facing
	var walking: bool
	var running: bool
	func _init(p: Vector2, f: Enums.Facing, w: bool, r: bool):
		pos = p
		facing = f
		walking = w
		running = r

func find_playable_character() -> PartyMember:
	for node in get_parent().get_children():
		if node is PartyMember and node.playable:
			return node
	return null
