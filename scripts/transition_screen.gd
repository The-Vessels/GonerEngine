# This is the CanvasLayer responsible for the
# fade to black animation between switching rooms
extends CanvasLayer

@onready var transition_rect: ColorRect = $TransitionRect

var fade_tween: Tween

func _ready() -> void:
	Signals.fadeFader.connect(
		func(start, end, time):
			if fade_tween and fade_tween.is_running():
				fade_tween.kill()
			fade_tween = create_tween()
			
			transition_rect.color.a = start
			fade_tween.tween_property(transition_rect, "color", Color(0, 0, 0, end), Util.frames_to_sec(time))
			await fade_tween.finished
			Signals.fadeEnd.emit()
	)
