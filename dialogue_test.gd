extends Node2D

@export var text: Array[String]
var text_progress := 0
@onready var textbox: TextBox = $Textbox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	textbox.visible = false
	textbox.text = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("confirm") and !textbox.animating:
		if text_progress < text.size():
			spawn_textbox(text[text_progress])
			text_progress += 1
		else:
			text_progress = 0
			textbox.visible = false
			textbox.text = ""
	
func spawn_textbox(text):
	textbox.visible = true
	textbox.text = text
	textbox.set_text(text)
	textbox.set_asterisks()
	textbox.animate_text()
