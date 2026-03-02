extends Node

# Documentation is here:
# https://store.steampowered.com/app/1671210/DELTARUNE/
enum {WORLD_LIGHT, WORLD_DARK}
var world_type = WORLD_DARK

var tension := 0
var maxtension := 250
var asp := AudioStreamPlayer.new()

var ui_menumove := preload('res://assets/sfx/ui/menumove.wav')

func _ready():
	setup_discord_rpc()

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
