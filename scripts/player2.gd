extends CharacterBody2D

const SPEED = 200.0
var facing = "down"
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

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

func _physics_process(delta: float) -> void:
	var move := Vector2.ZERO
	if Input.is_action_pressed('left'):
		move.x = -1.0
	elif Input.is_action_pressed('right'):
		move.x = 1.0
	if Input.is_action_pressed('up'):
		move.y = -1.0
	elif Input.is_action_pressed('down'):
		move.y = 1.0
	
	if not facing_same(move) and move != Vector2.ZERO:
		facing = facing_from_vec(move)
	
	var old_frame := sprite.frame
	var old_progress := sprite.frame_progress
	sprite.play('walk_' + facing)
	sprite.set_frame_and_progress(old_frame, old_progress)
	
	velocity = move * SPEED
	move_and_slide()
