class_name player extends CharacterBody2D

var speed := 90.0
var facing = "down"
var nopress := false

var happy_frames   := preload("res://assets/sprites/party/susie/susie_animations.tres")
var unhappy_frames := preload("res://assets/sprites/party/susie/susie_unhappy_animations.tres")
@onready var sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")

var old_frame := 0
func set_frame(frame: int):
	sprite.frame = frame
	if frame != old_frame:
		if frame == 1 or frame == 3:
			$Footstep.play()
	old_frame = frame

func set_anim(anim: String):
	var old_frame := sprite.frame
	sprite.animation = anim
	sprite.frame = old_frame

func facing_from_vec(move: Vector2):
	if move.x == 1.0:
		return 'right'
	if move.y == 1.0:
		return 'down'
	if move.x == -1.0:
		return 'left'
	if move.y == -1.0:
		return 'up'
	return null

func facing_same(move: Vector2):
	if facing == 'right':
		return move.x == 1.0
	if facing == 'left':
		return move.x == -1.0
	if facing == 'up':
		return move.y == -1.0
	if facing == 'down':
		return move.y == 1.0
	return null

func _init():
	if Global.world_type == Global.WORLD_DARK:
		speed = 90.0
	else:
		speed = 120.0

var walkbuffer := 0.0
var walktimer := 0.0
func _physics_process(delta: float) -> void:
	var move := Vector2.ZERO
	if !nopress:
		if Input.is_action_pressed('left'):
			move.x = -1.0
		elif Input.is_action_pressed('right'):
			move.x = 1.0
		if Input.is_action_pressed('up'):
			move.y = -1.0
		elif Input.is_action_pressed('down'):
			move.y = 1.0
	
	if Input.is_action_pressed('confirm'):
		sprite.sprite_frames = happy_frames
	elif Input.is_action_pressed('cancel'):
		sprite.sprite_frames = unhappy_frames
		sprite.speed_scale
	
	var walk := (move.x != 0.0) or (move.y != 0.0)
	if walk:
		walkbuffer = 6.0
	if walkbuffer > 3.0:
		walktimer += 1.5
		walktimer = fposmod(walktimer, 40.0)
		set_frame(int(walktimer / 10.0))
	elif walkbuffer <= 0.0 && velocity == Vector2(0, 0):
		walktimer = 10.0 * int(walktimer / 10.0) + 9.5
		set_frame(0)
	if walkbuffer > 0.0:
		walkbuffer -= 0.75
	
	if not facing_same(move) and move != Vector2.ZERO:
		facing = facing_from_vec(move)
	
	var old_frame := sprite.frame
	var old_progress := sprite.frame_progress
	sprite.play('walk_' + facing)
	sprite.set_frame_and_progress(old_frame, old_progress)
	
	if Input.is_action_pressed("cancel"):
		velocity = move * speed * 2
	else:
		velocity = move * speed
	move_and_slide()
