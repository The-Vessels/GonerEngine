extends TextureRect

func _ready():
	match Global.world_type:
		Global.WORLD_LIGHT:
			set_position(Vector2(64.0, 350.0))
		Global.WORLD_DARK:
			set_position(Vector2(69.0, 350.0))
