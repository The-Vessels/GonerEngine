# This is the root node of GonerEngine.
# It manages borders, fullscreen,
# and anything else that might be outside GameRoot.

extends Control

@onready var border_rect: TextureRect = $BorderAndGame/BorderTexture
@onready var border_prev_rect: TextureRect = $BorderAndGame/BorderPrevTexture
@onready var game_renderer: TextureRect = $GameRenderer

# Border variables
var border_tween: Tween

# The last center position of the window, before it was fullscreened.
# We use this to return the window's center to its original center,
# when it is unfullscreened.
var last_window_center: Vector2i
var was_windowed: bool = false

func _enter_tree() -> void:
	print('main enter tree')

func _ready() -> void:
	# Override project settings
	# so that the window does what it's supposed to.
	get_window().content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED
	
	border_rect.texture = find_border_texture()
	border_tween = create_tween()
	set_border()
	
	Signals.changeBorder.connect(
		func(border_texture, fade_frames):
			if border_rect.texture != border_texture:
				set_border_texture(border_texture, fade_frames)
	)
	Signals.ToggleBorder.connect(
		func(enable):
			Settings.border_enabled = enable
			set_border()
	)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		toggle_fullscreen()
	#if event.is_action_pressed("temporary_border_toggle"):
		#Settings.border_enabled = !Settings.border_enabled
		#set_border()
	
	# This passes keyboard events to the BorderAndGame viewport.
	# This has to be done manually because Godot does not automatically
	# send input events to the SubViewport.
	# This makes GUI elements in the SubViewport respond to keyboard input.
	if event is InputEventKey:
		$BorderAndGame.push_input(event)

func _process(_delta: float) -> void:
	#var texture := find_border_texture()
	#if border_rect.texture != texture:
		#set_border_texture(texture, 0)
	pass

func find_border_texture() -> Texture2D:
	if !Settings.border_enabled:
		return Global.BORDER_NONE
	
	match Settings.border_mode:
		Settings.BorderModes.NONE:
			return Global.BORDER_NONE
		Settings.BorderModes.SIMPLE:
			return Global.BORDER_SIMPLE
		Settings.BorderModes.DYNAMIC:
			return Global.current_dynamic_border
	
	return Global.BORDER_NONE

# Uses an animation to set the border to `new_border`.
func set_border_texture(new_border: Texture, duration: float) -> void:
	print('SET BORDER TEXTURE!!!')
	
	# Set the current texture to the previous texture
	# and set the new texture.
	border_prev_rect.texture = border_rect.texture
	border_rect.texture = new_border
	
	# We need to make the new border rect go from invisible to visible
	# over a period of 1 second.
	border_prev_rect.visible = true
	border_rect.modulate.a = 0.0
	
	border_tween.kill()
	border_tween = create_tween()
	border_tween.tween_property(border_rect, "modulate:a", 1.0, (duration / 30.0))
	border_tween.tween_callback(func(): border_prev_rect.visible = false)

# Get what the window size should be, which changes based on `Settings.border_enabled`.
func calculate_window_size():
	return Vector2i(960, 540) if Settings.border_enabled else Vector2i(640, 480)

# Enable or disable the border, based on `Settings.border_enabled`.
func set_border():
	# We use "double resolution" for the BorderAndGame viewport
	# because the border image is 1920x1080. If we were to actually make
	# the BorderAndGame viewport 960x540, it would downscale the border image.
	# (We could make BorderAndGame 640x480 when border is not showing,
	# but that would need the code to be slightly changed.)
	
	var window_size = calculate_window_size()
	
	$BorderAndGame.size = 2 * window_size
	if Settings.border_enabled:
		# letterbox if no border
		game_renderer.stretch_mode = TextureRect.StretchMode.STRETCH_KEEP_ASPECT_COVERED
	else:
		# fully cover the window if there is border
		game_renderer.stretch_mode = TextureRect.StretchMode.STRETCH_KEEP_ASPECT_CENTERED
	
	# If the window is in windowed mode,
	# keep the window's center in the same position
	# after resizing.
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		var center := get_window_center()
		get_window().size = window_size
		set_window_center(center)

# Toggles between windows and fullscreen.
# I think we should make this set_fullscreen(bool) instead
func toggle_fullscreen():
	var mode := DisplayServer.window_get_mode()
	
	if mode == DisplayServer.WINDOW_MODE_WINDOWED:
		was_windowed = true
		last_window_center = get_window_center()
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		get_window().size = calculate_window_size()
		if was_windowed:
			set_window_center(last_window_center)

func get_window_center() -> Vector2i:
	var window := get_window()
	return window.position + (window.size / 2)

func set_window_center(center: Vector2i):
	var window = get_window()
	window.position = center - (window.size / 2)
