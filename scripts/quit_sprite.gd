extends AnimatedSprite2D

var index := 0.0

# TODO why is this _physics_process???
func _physics_process(_delta: float) -> void:
	handle_quitting()

func handle_quitting():
	print(index)
	if Input.is_action_pressed("quit"):
		if index >= 5.0:
			# This is when GonerEngine quits.
			get_tree().quit()
		
		modulate.a += 0.05
		index += 0.1
	elif modulate.a > 0.0:
			index -= 0.5
			index = max(0, index)
			
			modulate.a -= 0.1
	else:
		index = 0.0
			
	modulate.a = clampf(modulate.a, 0.0, 1.0)
	#print("hi: " + str(quitting_sprite_index) + " becomes " + str(quitting_sprite.frame))
	frame = int(index)
