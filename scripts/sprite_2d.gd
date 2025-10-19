@tool
extends Sprite2D

@export var box_size := Vector2(50,50):
	set(new):
		box_size = new
		update()

var border_color := Color('#00C000')
var is_afterimage := false

func update() -> void:
	queue_redraw()

func _process(delta: float) -> void:
	if is_afterimage:
		modulate.a -= 1.2 * delta
		if modulate.a <= 0.0:
			queue_free()

func _draw() -> void:
	var box_pos = -box_size / 2.0
	var rect = Rect2(box_pos, box_size)
	if not is_afterimage:
		draw_rect(rect, Color.BLACK, true)
	draw_rect(rect, border_color, false, 4.0)
