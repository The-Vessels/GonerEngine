@icon("uid://cb5n8qeygaod0")
class_name BorderNode extends Node2D

@export var border_texture: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#if border_texture == Global.border_texture:
		#return
	#Global.current_dynamic_border = border_texture
	#if Global.border_mode == Global.BorderModes.sDYNAMIC:
		#Global.changeBorder.emit(border_texture)
	print('border ready')
	Global.set_dynamic_border(border_texture)
