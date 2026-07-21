extends Room

@onready var label: Label = $Label

var intro_activated := false
var room_change := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("confirm"):
		if intro_activated and !room_change:
			room_change = true
			Global.fade_music(0.0, 20)
			await Global.fader_fade(0.0, 1.0, 20)
			Room.goto(load("res://scenes/overworld/rooms/hometown.tscn"))
			await Global.fader_fade(1.0, 0.0, 20)
	
	if Global.mus_track_position == 0.0:
		if intro_activated and !room_change:
			room_change = true
			await Global.fader_fade(0.0, 1.0, 20)
			Room.goto(load("res://scenes/overworld/rooms/hometown.tscn"))
			await Global.fader_fade(1.0, 0.0, 20)
		label.visible_characters = 0
	if Global.mus_track_position > 0.0:
		label.visible_characters = 1
		intro_activated = true
	if Global.mus_track_position >= 1.38:
		label.visible_characters = 2
	if Global.mus_track_position >= 1.38*2:
		label.visible_characters = 3
	if Global.mus_track_position >= 1.38*3:
		label.visible_characters = 4
	if Global.mus_track_position >= 1.38*4:
		label.visible_characters = 5
	if Global.mus_track_position >= 1.38*5:
		label.visible_characters = 6
	if Global.mus_track_position >= 1.38*5.66:
		label.visible_characters = 7
	if Global.mus_track_position >= 1.38*6.0:
		label.visible_characters = 8
	if Global.mus_track_position >= 1.38*6.33:
		label.visible_characters = 9
	if Global.mus_track_position >= 1.38*6.66:
		label.visible_characters = 15
	if Global.mus_track_position >= 1.38*7.0:
		label.visible_characters = 21
	if Global.mus_track_position >= 1.38*7.33:
		label.visible_characters = 29
	if Global.mus_track_position >= 1.38*7.66:
		label.visible_characters = 32
