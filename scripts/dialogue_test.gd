extends Node2D

@export_multiline var text: Array[String]
const TEXTBOX = preload("uid://c5nrska6i801g")
var textbox_inst: TextBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("confirm") and !TextBox.has_textbox and Global.moveable:
		var textbox = TextBox.create(text)
		add_child(textbox)
		print("yo")
	
func spawn_textbox(text):
	var textbox_inst = TEXTBOX.instantiate()
	textbox_inst.text = text
	add_child(textbox_inst)
