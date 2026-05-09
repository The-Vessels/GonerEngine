extends Node
@onready var fps_counter: Label = $FPS_COUNTER
@onready var music_player: AudioStreamPlayer = $MusicPlayer

# Maybe figure out how to get these to be const
var c_white = Color.html("#FFFFFF")
var c_black = Color.html("#000000")
var c_aqua = Color.html("#00ffff");
var c_blue = Color.html("#0000ff");
var c_dkgray = Color.html("#404040");
var c_fuchsia = Color.html("#ff00ff");
var c_gray = Color.html("#808080");
var c_green = Color.html("#008000");
var c_lime = Color.html("#00ff00");
var c_ltgray = Color.html("#c0c0c0");
var c_maroon = Color.html("#800000");
var c_navy = Color.html("#000080");
var c_olive = Color.html("#808000");
var c_orange = Color.html("#ffa040");
var c_purple = Color.html("#800080");
var c_red = Color.html("#ff0000");
var c_silver = Color.html("#c0c0c0");
var c_teal = Color.html("#008080");
var c_yellow = Color.html("#ffff00");

# Documentation is here:
# https://store.steampowered.com/app/1671210/DELTARUNE/
enum {WORLD_LIGHT, WORLD_DARK}
var world_type = WORLD_DARK

var is_fullscreen := DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN

var border_enabled := false
enum BorderModes {
	DYNAMIC,
	SIMPLE,
	NONE
}
var border_mode := BorderModes.DYNAMIC
var border_trans := 1.0
var border_texture: Texture2D
var current_dynamic_border: Texture2D
signal changeBorder(border)
signal changeMusic(music, pitch)

var currentRoom: PackedScene
signal changeRoom(room, target, facing)

# change this to undefined later its 0 for testing pur's
var currentHero = 0

var tension := 0
var maxtension := 250
var asp := AudioStreamPlayer.new()

var ui_menumove := preload('res://assets/sounds/ui/menumove.wav')

var selectedDarkBtn := 0
var darkMenuOpened := false
var darkSubmenuOpened := false

func _ready():
	setup_discord_rpc()
	
func _physics_process(_delta: float) -> void:
	fps_counter.text = "FPS: " + str(int(Engine.get_frames_per_second()))

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		toggle_fullscreen()
	if Input.is_key_pressed(KEY_F2):
		get_tree().reload_current_scene()

func setup_discord_rpc():
	DiscordRPC.app_id = 1416858009635913738
	DiscordRPC.details = 'Playing GonerEngine'
	DiscordRPC.state = 'Somewhere in GonerEngine'
	DiscordRPC.large_image = 'gonerenginelogo'
	DiscordRPC.large_image_text = 'Gaster!!!'
	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system())
	DiscordRPC.refresh()

func play_ui_sound(sound_name: String):
	$UIAudioPlayer.stream = load('res://assets/sfx/ui/' + sound_name + '.wav')
	$UIAudioPlayer.play()
	
func toggle_fullscreen():
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		if !border_enabled:
			get_window().content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED
			get_window().content_scale_stretch = Window.CONTENT_SCALE_STRETCH_INTEGER
			
			get_window().size = Vector2(640, 480)
		else:
			get_window().size = Vector2(960, 540)
		is_fullscreen = false
		print(get_window().position)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		if !border_enabled:
			get_window().content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
			get_window().content_scale_stretch = Window.CONTENT_SCALE_STRETCH_FRACTIONAL
		is_fullscreen = true
		print(get_window().position)
