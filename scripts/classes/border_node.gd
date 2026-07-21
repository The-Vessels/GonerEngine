@icon("uid://cb5n8qeygaod0")
class_name BorderNode extends Node2D
## A Node2D used for setting the dynamic border in a [Room].
## 
## [b]Note:[/b] This doesn't need to be set in every room. The dynamic border set by a [b]BorderNode[/b] will stay until it is overridden by another [b]BorderNode[/b].

@export var border_texture: Texture2D
@export var frames_length: float = 30.0

# Used for a room's border node to set the dynamic border.
## Sets the current dynamic border to a given loaded [param texture] resource
## and fades to it in a given [param time].
## [codeblock]
## BorderNode.set_dynamic_border(load("res://sprites/borders/border_simple.png"), 30)
## [/codeblock]
func set_dynamic_border(texture: Texture2D, time: float):
	Global.current_dynamic_border = texture
	if Settings.border_mode == Settings.BorderModes.DYNAMIC:
		Signals.changeBorder.emit(Global.current_dynamic_border, time)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#if border_texture == Global.border_texture:
		#return
	#Global.current_dynamic_border = border_texture
	#if Global.border_mode == Settings.BorderModes.sDYNAMIC:
		#Global.changeBorder.emit(border_texture)
	print('border ready')
	set_dynamic_border(border_texture, frames_length)
