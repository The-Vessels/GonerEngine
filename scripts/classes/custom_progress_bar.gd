# IDK if this should actually be called "CustomProgressBar"
@tool
class_name CustomProgressBar extends Control

@export var value: float:
	set(new_value):
		value = new_value
		queue_redraw()
@export var text_offset: Vector2:
	set(new_value):
		text_offset = new_value
		queue_redraw()
@export var fill_color: Color:
	set(new_value):
		fill_color = new_value
		queue_redraw()
@export var background_color: Color:
	set(new_value):
		background_color = new_value
		queue_redraw()
@export var text_color: Color:
	set(new_value):
		text_color = new_value
		queue_redraw()

func get_value_string() -> String:
	return str(roundi(value)) + "%"

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		queue_redraw()

func _draw() -> void:
	var fill_size := Vector2(size.x * (value / 100.0), size.y)
	var font := get_theme_default_font()
	var font_size := get_theme_default_font_size()
	var font_height := font.get_height()
	var text_pos := text_offset + Vector2(0.0, font_height)
	
	draw_rect(Rect2(Vector2.ZERO, size), background_color)
	draw_rect(Rect2(Vector2.ZERO, fill_size), fill_color)
	draw_string(
		font, text_pos, get_value_string(),
		HorizontalAlignment.HORIZONTAL_ALIGNMENT_LEFT, -1.0,
		font_size, text_color
	)
