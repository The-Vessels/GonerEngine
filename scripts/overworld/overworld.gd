extends Node2D

func _ready():
	var tween = create_tween()
	tween.tween_property(self, 'modulate', Color.WHITE, 0.25).from(Color.BLACK)
