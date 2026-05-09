extends Node2D

@export var text: Array[String]
var text_progress := 0
var TEXTBOX = preload("uid://c5nrska6i801g")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("confirm"):
		if get_child_count() > 0:
			var ch = get_child(0)
			ch.queue_free()
		if text_progress < text.size():
			spawn_textbox(text[text_progress])
			text_progress += 1
		else:
			text_progress = 0
	
func spawn_textbox(text):
	var instantiated = TEXTBOX.instantiate()
	instantiated.text = text
	add_child(instantiated)
