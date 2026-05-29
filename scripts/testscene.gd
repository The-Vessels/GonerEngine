extends Control

func _ready() -> void:
	var window := get_window()
	window.size = Vector2i(960, 540)
	window.content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED
	window.content_scale_stretch = Window.CONTENT_SCALE_STRETCH_INTEGER
	window.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	window.unresizable = false

func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_F):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif Input.is_key_pressed(KEY_R):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
