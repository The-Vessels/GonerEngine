@icon("uid://dedigvj6gn7wg")
class_name MusicNode extends Node2D
## A Node2D used for setting the music track in a [Room].
## 
## [b]Note:[/b] This doesn't need to be set in every room. The music track set by a [b]MusicNode[/b] will stay until it is overridden by another [b]MusicNode[/b].

@export var music: AudioStream
@export_range(0.01, 4.00) var pitch: float = 1.00
# This is linear btw
@export_range(0.0, 4.0) var gain: float = 1.0

## Changes the global music playing to the given loaded [param music] resource
## with the given [param gain] and [param pitch]
## [br][br]
## [b]Note:[/b] [param gain] is in linear energy.
## [codeblock]
## MusicNode.change_music(load("res://music/mus_intro_test.ogg"), 0.75, 1.17)
## [/codeblock]
static func change_music(music: AudioStream, gain: float = 1.0, pitch: float = 1.00) -> void:
	Signals.changeMusic.emit(music, gain, pitch)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.music_player.stream != music:
		change_music(music, gain, pitch)
