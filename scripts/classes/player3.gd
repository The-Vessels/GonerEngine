@icon("uid://ckhgwh7y265re")
class_name Player extends CharacterBody2D

var speed := 90.0
var runspeed := 180.0
var facing = "down"
var running := false

var happy_frames   := preload("res://sprites/actors/susie/susie_animations.tres")
var unhappy_frames := preload("res://sprites/actors/susie/susie_unhappy_animations.tres")
@onready var sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var shape_cast: ShapeCast2D = $ShapeCast2D

var old_frame := 0
func set_frame(frame: int):
	sprite.frame = frame
	if frame != old_frame:
		if frame == 1 or frame == 3:
			$Footstep.play()
	old_frame = frame

func set_anim(anim: String):
	old_frame = sprite.frame
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
	if Global.world_type == Global.WorldTypes.WORLD_DARK:
		speed = 90.0
	else:
		speed = 120.0

var walkbuffer := 0.0
var walktimer := 0.0
func _physics_process(_delta: float) -> void:
	var move := Vector2.ZERO
	if Global.moveable:
		if OS.has_feature("mobile"):
			var dir = Input.get_vector("left", "right", "up", "down")
			move = Vector2(snappedf(dir.x, 1.0), snappedf(dir.y, 1.0))
		else:
			if Input.is_action_pressed('left'):
				move.x = -1.0
				print("left")
			elif Input.is_action_pressed('right'):
				move.x = 1.0
				print("right")
			if Input.is_action_pressed('up'):
				move.y = -1.0
				print("up")
			elif Input.is_action_pressed('down'):
				move.y = 1.0
				print("down")
	
	if Input.is_action_pressed('confirm'):
		sprite.sprite_frames = happy_frames
	if Input.is_action_pressed('cancel'):
		sprite.sprite_frames = unhappy_frames
		running = true
	else:
		running = false
	
	var walk := (move.x != 0.0) or (move.y != 0.0)
	if walk:
		walkbuffer = 6.0
	if walkbuffer > 3.0:
		walktimer += 1.5 if !running else 2.5
		walktimer = fposmod(walktimer, 40.0)
		set_frame(int(walktimer / 10.0))
	elif walkbuffer <= 0.0 && velocity == Vector2(0, 0):
		walktimer = 10.0 * int(walktimer / 10.0) + 9.5
		set_frame(0)
	if walkbuffer > 0.0:
		walkbuffer -= 0.75
	
	if not facing_same(move) and move != Vector2.ZERO:
		facing = facing_from_vec(move)
	
	old_frame = sprite.frame
	var old_progress := sprite.frame_progress
	sprite.play('walk_' + facing)
	sprite.set_frame_and_progress(old_frame, old_progress)
	
	if Input.is_action_pressed("cancel"):
		if speed < runspeed:
			speed += 5
	else:
		speed = 90
	velocity = move * speed
	move_and_slide()
	if Input.is_action_just_pressed("confirm"):
		match facing:
			"left":
				shape_cast.target_position = Vector2(-2, 0)
			"up":
				shape_cast.target_position = Vector2(0, -2)
			"right":
				shape_cast.target_position = Vector2(2, 0)
			"down":
				shape_cast.target_position = Vector2(0, 2)
		for node in shape_cast.collision_result:
			print(node.collider is TeleportArea)
		shape_cast.target_position = Vector2(0, 0)
