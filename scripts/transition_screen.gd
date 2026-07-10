# This is the CanvasLayer responsible for the
# fade to black animation between switching rooms
extends CanvasLayer

@onready var transition_rect: ColorRect = $TransitionRect

var fade_tween: Tween

func _ready() -> void:
	#print('PPPPPP')
	Signals.fadeFader.connect(
		func(start, end, time, time_unit):
			if fade_tween and fade_tween.is_running():
				fade_tween.kill()
			fade_tween = create_tween()
			
			var duration = time
			if time_unit == Enums.TimeUnits.PHYSICS_FRAME:
				duration = time / 30.0
			
			transition_rect.color.a = start
			fade_tween.tween_property(transition_rect, "color", Color(0, 0, 0, end), duration)
			await fade_tween.finished
			Signals.fadeEnd.emit()
	)
