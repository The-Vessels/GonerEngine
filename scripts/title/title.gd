extends Node2D

func _ready():
	var tween1 := create_tween()
	tween1 \
		.tween_property($AudioStreamPlayer, 'pitch_scale', 0.98, 5.0) \
		.from(0.02)
	
	
	$Titletext.modulate.a = 0.0
	var tween2 := create_tween()
	tween2 \
		.tween_property($ImageDepth, 'modulate', Color.WHITE, 2.5) \
		.from(Color.BLACK)
	tween2 \
		.tween_property($Titletext, 'modulate:a', 1.0, 2.5) \
		.from(0.0)
	
	
	$Menu/Soul.modulate.a    = 0.0
	$Menu/Choices.modulate.a = 0.0
	
	var tween3 := create_tween()
	tween3.tween_interval(4.25)
	tween3 \
		.tween_property($Menu/Soul, 'modulate:a', 1.0, 0.5) \
		.from(0.0)
	
	var tween4 := create_tween()
	tween4.tween_interval(4.5)
	tween4 \
		.tween_property($Menu/Choices, 'modulate:a', 1.0, 0.5) \
		.from(0.0)
