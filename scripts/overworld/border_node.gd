class_name BorderNode extends Node2D

@export var border_texture: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if border_texture == Global.border_texture:
		return
	if Global.border_mode == Global.BorderModes.DYNAMIC:
		Global.changeBorder.emit(border_texture)
