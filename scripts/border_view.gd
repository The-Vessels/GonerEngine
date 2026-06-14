extends SubViewportContainer
@onready var border_rect: TextureRect = $SubViewport/BorderTexture
@onready var border_prev_rect: TextureRect = $SubViewport/BorderPrevTexture
var tween: Tween

const BORDER_SIMPLE = preload("uid://rfitwotdwjpa")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tween = get_tree().create_tween()
	Global.border_texture = border_rect.texture
	Global.changeBorder.connect(
		set_border
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("temporary_border_toggle"):
		toggle_border()
	
	visible = true if Global.border_enabled else false
	
	match Global.border_mode:
		Settings.BorderModes.NONE:
			border_rect.texture = null
		Settings.BorderModes.SIMPLE:
			border_rect.texture = BORDER_SIMPLE
		Settings.BorderModes.DYNAMIC:
			border_rect.texture = Global.border_texture
			
	if Global.border_trans < 1.0:
		border_prev_rect.modulate.a = 1.0 - Global.border_trans
	else:
		border_prev_rect.modulate.a = 0.0
	border_rect.modulate.a = Global.border_trans
	
	border_rect.modulate.a = clampf(border_rect.modulate.a, 0.0, 1.0)

func set_border(new_border):
	if !Global.border_enabled:
		return
	
	border_prev_rect.texture = border_rect.texture
	Global.border_texture = new_border
	
	Global.border_trans = 0.0
	
	tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(Global, "border_trans", 1.0, 1.0)
	
func toggle_border():
	if Input.is_action_just_pressed("temporary_border_toggle"):
		var prev_size := get_window().size
		print(get_window().position)
		if Global.border_enabled:
			if Settings.is_fullscreen:
				get_window().content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
				get_window().content_scale_stretch = Window.CONTENT_SCALE_STRETCH_FRACTIONAL
			else:
				get_window().size = Vector2(640, 480)
			get_window().position -= (get_window().size - prev_size) / 2
				
			Global.border_enabled = false
			Global.border_texture = null
		else:
			if Settings.is_fullscreen:
				get_window().content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED
				get_window().content_scale_stretch = Window.CONTENT_SCALE_STRETCH_INTEGER
				
			else:
				get_window().size = Vector2(960, 540)
			get_window().position += (prev_size - get_window().size) / 2
			Global.border_enabled = true
			set_border(Global.current_dynamic_border)
