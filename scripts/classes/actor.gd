class_name Actor extends CharacterBody2D
## Anyone who can be controlled
## by a cutscene.

@export var chara: Character

# An actor dict to store all the actors.
static var actor_dict: Dictionary[String, Actor] = {}

func _enter_tree() -> void:
	actor_dict[chara.name] = self

func _exit_tree() -> void:
	actor_dict[chara.name] = null

func _ready() -> void:
	$AnimatedSprite2D.play("face_down")

static func get_by_name(actor_name: String) -> Actor:
	return actor_dict.get(actor_name)

static func exists(actor_name: String) -> bool:
	return actor_dict.has(actor_name)

# Returns the walk speed in FPS.
func calc_walk_fps(point: Vector2, time: float) -> float:
	# Supposed to be 1 for light and 2 for dark worlds
	# But we need to figure out this later
	var dw := 2
	var px_per_sec := position.distance_to(point) / time
	var speed := px_per_sec / (10 * dw)
	return clamp(speed, 7.5, 15.0)

# Set the actual FPS of the animatedsprite2d
# TODO should we actually do this? I think
# we should set the speed scale here just like Deltarune
# does. The only reason I'm not doing it is because
# it would mess with character walking.
func set_fps(fps: float):
	print('SETTING FPS TO ', fps)
	var sf: SpriteFrames = $AnimatedSprite2D.sprite_frames
	var anim_fps := sf.get_animation_speed($AnimatedSprite2D.animation)
	$AnimatedSprite2D.speed_scale = fps / anim_fps

func walk_to_point(point: Vector2, time: float):
	var direction := point - position
	var facing := Enums.facing_from_dir(direction)
	var anim_name := "walk_" + Enums.facing_to_string(facing)
	$AnimatedSprite2D.play(anim_name)
	set_fps(calc_walk_fps(point, time))
	# $AnimatedSprite2D.speed_scale
	
	var tween := create_tween()
	tween.tween_property(self, "position", point, time / 30.0)
	tween.tween_callback($AnimatedSprite2D.stop)
	await tween.finished
