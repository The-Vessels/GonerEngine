extends CanvasLayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal transitioned

func transition():
	animation_player.play("fade_to_black")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_to_black":
		transitioned.emit()
		animation_player.play("fade_to_normal")
