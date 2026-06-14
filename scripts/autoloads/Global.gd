extends Node
@onready var fps_counter: Label = $FPS_COUNTER
@onready var ui_audio_player: AudioStreamPlayer = $UIAudioPlayer
@onready var music_player: AudioStreamPlayer = $MusicPlayer

# Documentation is here:
# https://store.steampowered.com/app/1671210/DELTARUNE/
enum WorldTypes {WORLD_LIGHT, WORLD_DARK}
var world_type = WorldTypes.WORLD_DARK

#var is_fullscreen := DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN

# var border_enabled := false
#enum BorderModes {
	#DYNAMIC,
	#SIMPLE,
	#NONE
#}
#var border_mode := BorderModes.DYNAMIC
const BORDER_NONE = preload("res://sprites/borders/border_none.png")
const BORDER_SIMPLE = preload("res://sprites/borders/border_simple.png")
var current_dynamic_border: Texture2D = preload("res://sprites/borders/border_none.png")
# signal changeBorder(border_texture)

signal changeMusic(music, pitch)

var currentRoom: PackedScene
signal changeRoom(room, target, facing)

# change this to undefined later its 0 for testing pur's
var currentHero = 0

var tension := 0
var maxtension := 250
var asp := AudioStreamPlayer.new()

var ui_menumove := preload("res://sounds/ui/menumove.wav")

func _ready():
	setup_discord_rpc()
	
func _physics_process(_delta: float) -> void:
	fps_counter.text = "FPS: " + str(int(Engine.get_frames_per_second()))

func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed("fullscreen"):
		#toggle_fullscreen()
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
	var stream = load('res://sounds/ui/' + sound_name + '.wav')
	var temp_sound_player = AudioStreamPlayer.new()
	temp_sound_player.name = "StupidAudioPlayer"
	temp_sound_player.finished.connect(
		func():
			temp_sound_player.queue_free()
	)
	temp_sound_player.stream = stream
	add_child(temp_sound_player)
	temp_sound_player.play()
	
# Used for a room's border node to set the dynamic border.
func set_dynamic_border(texture: Texture2D):
	current_dynamic_border = texture

#func toggle_fullscreen():
	#if is_fullscreen:
		#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		#if !border_enabled:
			#get_window().content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED
			#get_window().content_scale_stretch = Window.CONTENT_SCALE_STRETCH_INTEGER
			#
			#get_window().size = Vector2(640, 480)
		#else:
			#get_window().size = Vector2(960, 540)
		#is_fullscreen = false
	#else:
		#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		#if !border_enabled:
			#get_window().content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
			#get_window().content_scale_stretch = Window.CONTENT_SCALE_STRETCH_FRACTIONAL
		#is_fullscreen = true
