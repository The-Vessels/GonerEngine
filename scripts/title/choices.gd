extends VBoxContainer

func _draw() -> void:
	var font: Font = $Play.get_theme_font("font")
	var pos = $Play.position + Vector2(0.0, 16.0 + 8.0)
	draw_string(font, pos, "PLAY", 0, -1, 32, Color.BLUE)
