@icon("uid://bhgevihtdcq37")
class_name Room extends Node2D

@export var world_type: Global.WorldTypes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.world_type = world_type


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
