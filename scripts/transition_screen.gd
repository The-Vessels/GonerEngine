# This is the CanvasLayer responsible for the
# fade to black animation between switching rooms

extends CanvasLayer
@onready var transition_player: AnimationPlayer = $TransitionPlayer

signal transitioned

func transition():
	transition_player.play("fade_to_black")

func _on_transition_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_to_black":
		transitioned.emit()
		transition_player.play("fade_to_normal")
