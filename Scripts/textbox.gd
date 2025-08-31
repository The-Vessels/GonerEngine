extends Control

var text = "* Dreemurr residence, is
	this real? uh, uh uh,
	uh uh, hu hu huh uh uhu"
@onready var dialoguetext: Label = $Box/dialoguetext
@onready var talkblip: AudioStreamPlayer = $talkblip

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialoguetext.text = ""
	for char in text:
		dialoguetext.text += char
		if not (char == "*" or char == " "):
			talkblip.play()
		await get_tree().physics_frame


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
