@icon("uid://dedigvj6gn7wg")
class_name MusicNode extends Node2D

@export var music: AudioStream
@export var pitch: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.music_player.stream != music:
		Global.changeMusic.emit(music, pitch)
