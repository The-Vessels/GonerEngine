extends Node2D

func _ready() -> void:
	global_scale = Vector2.ONE
	global_position = WorldCamera.get_pos()

func _process(delta: float) -> void:
	global_position = WorldCamera.get_pos()
