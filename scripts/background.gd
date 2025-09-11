@tool
extends ColorRect

@export var set_screen_resolution: bool = false:
	set(new):
		material.set_shader_parameter('screen_resolution', size)
