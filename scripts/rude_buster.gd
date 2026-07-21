extends Node2D
var target:Vector2
@export var rude_bolt:Node2D
@export var dummy_bolt:Sprite2D
var direction:float = 0
var dir:float = 0
var speed:float = 24
var friction:float = -1.5
var afterimg_timer = 0.0
var t = 0
var lastpos:Vector2 = Vector2(-1,-1)
@export var afterimage_scene:PackedScene
var afterimage_obj:Afterimage

func _ready() -> void:
	rude_bolt.modulate.a = 0
	get_tree().paused = true
	target = $Target.position
	rude_bolt.rotation_degrees = rad_to_deg(rude_bolt.get_angle_to(target)) + 20
	#rude_bolt.angular_velocity = 24 * 30
	#rude_bolt.velocity = 24 * 30
	
#function from https://forum.godotengine.org/t/equivalent-of-gamemakerss-function-angle-difference/27163

		

	
func _process(delta: float) -> void:
	pass
	#dir = rad_to_deg(rude_bolt.get_angle_to(target))
	#rude_bolt.rotation_degrees += (rad_to_deg(rude_bolt.get_angle_to(target)) - rude_bolt.rotation_degrees) / (4 * (30 * delta))
	#rude_bolt.look_at(target)
	#dir = rad_to_deg(rude_bolt.rotation)
	#direction += deg_to_rad(angle_difference(dir,direction) / 4)
	#$"Rude Bolt".rotation = direction
	#$"Rude Bolt".position += 4.75 * 30 * delta * transform.x
	
	
func _summon_afterimage():
		if lastpos == Vector2(-1,-1):
			return
		var afterimage_obj = afterimage_scene.instantiate()
		afterimage_obj.texture = rude_bolt.sprite_frames.get_frame_texture(rude_bolt.animation, rude_bolt.frame)
		afterimage_obj.global_position = lastpos
		
		afterimage_obj.rotation = rude_bolt.rotation
		afterimage_obj.centered = true
		afterimage_obj.scale = Vector2(2,1.8)
	
		add_child(afterimage_obj)
		
func _physics_process(delta: float) -> void:
	rude_bolt.modulate.a += 0.25


	dir = rad_to_deg(rude_bolt.get_angle_to(target))
	rude_bolt.rotation_degrees += (rad_to_deg(rude_bolt.get_angle_to(target)) - rude_bolt.rotation_degrees) / 4
	lastpos = rude_bolt.global_position
	rude_bolt.position += rude_bolt.transform.x * speed
	speed -= friction
	afterimg_timer += 1 * delta

		

		
	
	if rude_bolt.position.distance_to(target) < 40:
		print("hi")
		rude_bolt.position = target
		rude_bolt.visible = false
	if rude_bolt.visible:
		_summon_afterimage()
