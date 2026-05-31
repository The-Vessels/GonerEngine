extends CharacterBody2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sprite_2d: Sprite2D = $Sprite2D

var speed = 90.0
var runspeed = 180
var seek := 0.0
var last_facing_direction := Vector2(0, -1)

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
	
	velocity = move * speed
	if velocity:
		last_facing_direction = move
		print(sprite_2d.texture)
		seek += 0.05
	animation_tree.set("parameters/TimeSeek/seek_request", seek)
	
	animation_tree.set("parameters/PlayerStates/Idle/blend_position", last_facing_direction)
	animation_tree.set("parameters/PlayerStates/Walk/blend_position", last_facing_direction)
	
	if Input.is_action_pressed("cancel"):
		animation_tree.set("parameters/TimeScale/scale", 2.0)
		if speed < runspeed:
			speed += 10
		else:
			speed = runspeed
	else:
		animation_tree.set("parameters/TimeScale/scale", 1.0)
		speed = 90.0
	move_and_slide()
