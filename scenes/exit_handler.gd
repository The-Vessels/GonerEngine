extends Node2D

var tween: Tween = null

func _input(event):
	if event.is_action_pressed('ui_cancel'):
		tween = create_tween()
		tween.tween_property($QuitLabel, 'modulate:a', 1.0, 0.1)
		tween.tween_property($QuitLabel, 'text', 'QUITTING...', 1.9).from('QUITTING')
		tween.tween_callback(get_tree().quit)
	elif event.is_action_released('ui_cancel'):
		if tween != null:
			tween.kill()
			tween = null
		var reset_tween = create_tween()
		reset_tween.tween_property($QuitLabel, 'modulate:a', 0.0, 0.1)
		reset_tween.tween_callback(func(): $QuitLabel.text = 'QUITTING')
