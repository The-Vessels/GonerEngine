@tool
extends Sprite2D

@export var box_size := Vector2(50,50):
	set(new):
		box_size = new
		update()
@export var update_button := false:
	set(new):
		update_button = new
		update()

func update() -> void:
	queue_redraw()

func _draw() -> void:
	var box_pos = -box_size / 2.0
	var rect = Rect2(box_pos, box_size)
	draw_rect(rect, Color.GREEN, false, 4.0)
	draw_rect(rect, Color.BLACK, true)
