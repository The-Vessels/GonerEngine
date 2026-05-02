@tool
extends Sprite2D

@export var grid_spacing := 20

func _draw():
	draw_rect(get_viewport_rect(), Color.BLACK, true)
	#draw_line()
