extends Sprite2D

var size := Vector2(25, 196)
var bottom_left_point := Vector2(3, size.y - 1)
#var rect := Rect2(Vector2.ZERO, size)

var tensionmarker := preload("res://sprites/battle/tensionbar/marker.png")

# TODO Kristal makes these floats, but idk if we should
var apparent_tp := float(Global.tension)
var current_tp  := float(Global.tension)


func change_apparent(dtmult: float):
	if abs(apparent_tp - Global.tension) < 20:
		apparent_tp = Global.tension
	elif apparent_tp < Global.tension:
		apparent_tp += 20 * dtmult
	else:
		apparent_tp -= 20 * dtmult

func change_current_once(thresh: int, change: int, negate: bool, dtmult: float):
	var diff := apparent_tp - current_tp
	if negate:
		if diff < -thresh:
			current_tp -= change * dtmult
	else:
		if diff > thresh:
			current_tp += change * dtmult

func change_current_half(negate: bool, dtmult: float):
	change_current_once(0,   2, negate, dtmult)
	change_current_once(10,  2, negate, dtmult)
	change_current_once(25,  3, negate, dtmult)
	change_current_once(50,  4, negate, dtmult)
	change_current_once(100, 5, negate, dtmult)

func change_current(dtmult: float):
	if current_tp != apparent_tp:
		change_current_half(false, dtmult)
		change_current_half(true,  dtmult)
		if abs(apparent_tp - current_tp) < 3:
			current_tp = apparent_tp

func _process(delta: float):
	var dtmult := delta * 30
	var old_current_tp := current_tp
	
	change_apparent(dtmult)
	change_current(dtmult)
	
	if int(current_tp) != int(old_current_tp):
		queue_redraw()

func draw_bar_rect(color: Color, px: int):
	var rect_size := Vector2(size.x - 4, -px + 1)
	var rect := Rect2(bottom_left_point, rect_size)
	draw_rect(rect, color)

func _draw():
	if current_tp == 0:
		return
	
	var apparent_ratio: float = apparent_tp / Global.maxtension
	var current_ratio:  float = current_tp  / Global.maxtension
	var apparent_px := int(apparent_ratio * size.y)
	var current_px  := int(current_ratio  * size.y)
	
	if apparent_tp < current_tp:
		draw_bar_rect(Color.RED, current_px)
		draw_bar_rect(Colors.c_orange,  apparent_px)
	elif apparent_tp > current_tp:
		draw_bar_rect(Color.WHITE, apparent_px)
		draw_bar_rect(Colors.c_orange,    current_px)
	else:
		draw_bar_rect(Colors.c_orange, current_px)
	
	if apparent_tp > 20 and apparent_tp < Global.maxtension:
		draw_texture(tensionmarker, Vector2(3, size.y - current_px))
