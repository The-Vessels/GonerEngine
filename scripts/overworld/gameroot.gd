# This is the root node of the main game.
# For now it just handles scaling the game

extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	scale = Vector2(2.0, 2.0) if (Settings.is_fullscreen and Settings.border_enabled) else Vector2(1.0, 1.0)
