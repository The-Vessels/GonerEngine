extends Control

var text = "* Yo Kris... I'm like, test dialogue and stuff..."
@onready var dialoguetext: Label = $Box/dialoguetext
@onready var talkblip: AudioStreamPlayer = $talkblip

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for char in text:
		dialoguetext.text += char
		if not (char == "*" or char == " "):
			talkblip.play()
		await get_tree().create_timer(0.001).timeout


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
