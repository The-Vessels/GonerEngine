extends CharacterBody2D

const SPEED = 200.0
var FACING = "facing_down"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var xdirection := Input.get_axis("left", "right")
	var ydirection := Input.get_axis("up", "down")

	if xdirection:
		velocity.x = xdirection * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if ydirection:
		velocity.y = ydirection * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	if xdirection == 0 and ydirection == 0:
		animated_sprite_2d.stop()
	# Animation
	if Input.is_action_just_pressed("left"):
		animated_sprite_2d.play("walk_left")
		FACING = "facing_left"
	elif Input.is_action_just_pressed("right"):
		animated_sprite_2d.play("walk_right")
		FACING = "facing_right"

	if Input.is_action_just_pressed("up"):
		animated_sprite_2d.play("walk_up")
		FACING = "facing_up"
	elif Input.is_action_just_pressed("down"):
		animated_sprite_2d.play("walk_down")
		FACING = "facing_down"

	move_and_slide()
