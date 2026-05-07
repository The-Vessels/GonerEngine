extends Node2D
@onready var quitting_sprite: AnimatedSprite2D = $CenterContainer/GameView/SubViewport/Node2D/CanvasLayer/AnimatedSprite2D
var quitting_sprite_index := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scale = Vector2(2.0, 2.0) if (Global.is_fullscreen and Global.border_enabled) else Vector2(1.0, 1.0)

func _physics_process(delta: float) -> void:
	handle_quitting()

func handle_quitting():
	if Input.is_action_pressed("quit"):
		if quitting_sprite_index >= 5.0:
			get_tree().quit()
		
		quitting_sprite.modulate.a += 0.05
		quitting_sprite_index += 0.1
	elif quitting_sprite.modulate.a > 0:
			quitting_sprite_index -= 0.5
			quitting_sprite_index = max(0, quitting_sprite_index)
			
			quitting_sprite.modulate.a -= 0.1
	else:
		quitting_sprite_index = 0.0
			
	quitting_sprite.modulate.a = clampf(quitting_sprite.modulate.a, 0.0, 1.0)
	#print("hi: " + str(quitting_sprite_index) + " becomes " + str(quitting_sprite.frame))
	quitting_sprite.frame = int(quitting_sprite_index)
