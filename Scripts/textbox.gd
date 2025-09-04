extends Control

var text = "* Dreemurr residence, whooooo is this?"
@onready var dialoguetext: Label = $Box/dialoguetext
@onready var talkblip: AudioStreamPlayer = $talkblip

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialoguetext.visible_characters_behavior = TextServer.VC_CHARS_AFTER_SHAPING
	dialoguetext.visible_characters = 0
	dialoguetext.text = text
	if text[0] == "*":
		dialoguetext.visible_characters = 1
	for char in text:
		dialoguetext.visible_characters += 1
		talkblip.play()
		await get_tree().physics_frame
	#dialoguetext.text = ""
	#for char in text:
		#dialoguetext.text += char
		#if not (char == "*" or char == " "):
			#talkblip.play()
		#await get_tree().physics_frame


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
