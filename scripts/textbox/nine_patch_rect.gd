extends NinePatchRect

func _ready():
	match Global.world_type:
		Global.WORLD_LIGHT:
			texture = load("res://Assets/Sprites/textbox/light/lighttextbox.png")
		Global.WORLD_DARK:
			texture = load("res://Assets/Sprites/textbox/dark/darktextbox1.png")
