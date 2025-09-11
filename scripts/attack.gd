extends Node2D
@export var attack_length:float
@export var attack_interval:=0.5
@export var bullet:PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Bullet Interval".wait_time = attack_interval




func _spawn_bullet(bullet_path:PackedScene):
	var bullet = bullet_path.instantiate()
	bullet.position = $Marker2D.position
	add_sibling(bullet)


func _on_bullet_interval_timeout() -> void:
	_spawn_bullet(bullet)
