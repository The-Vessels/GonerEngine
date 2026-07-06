# This is the CanvasLayer responsible for the
# fade to black animation between switching rooms
extends CanvasLayer

@onready var transition_rect: ColorRect = $TransitionRect

func _ready() -> void:
	Signals.fadeFader.connect(
		func(start, end, time, time_unit):
			var tween = create_tween()
			
			var duration = time
			if time_unit == Enums.TimeUnits.PHYSICS_FRAME:
				duration = time / 30.0
			
			transition_rect.color.a = start
			tween.tween_property(transition_rect, "color", Color(0, 0, 0, end), duration)
			await tween.finished
			Signals.fadeEnd.emit()
	)
