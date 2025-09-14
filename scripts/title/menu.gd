extends Node2D

@export var speed := 1.0
var choice := 0
@onready var n_choices = $Choices.get_child_count()

enum {
	CHOICE_PLAY,
	CHOICE_CONFIG,
	CHOICE_QUIT,
	CHOICE_NUMBER
}

func get_choice(idx: int) -> Label:
	return $Choices.get_child(idx)

func _ready():
	get_choice(choice).modulate = Color.YELLOW

func _input(event):
	var old_choice := choice
	if event.is_action_pressed('down'):
		choice = posmod(choice + 1, CHOICE_NUMBER)
	if event.is_action_pressed('up'):
		choice = posmod(choice - 1, CHOICE_NUMBER)
	if old_choice != choice:
		get_choice(old_choice).modulate = Color.WHITE
		get_choice(choice).modulate = Color.YELLOW
	if event.is_action_pressed('confirm'):
		if choice == CHOICE_PLAY:
			go_to_overworld()
		elif choice == CHOICE_QUIT:
			get_tree().quit()

func _process(delta: float) -> void:
	var pos := get_choice(choice).get_screen_position()
	# $Soul.set_position(pos)
	$Soul.position = $Soul.position.lerp(pos, 0.5)
	# position.y = move_toward(position.y, pos.y, delta * speed)

func go_to_overworld():
	get_tree().change_scene_to_packed(preload('res://scenes/overworld.tscn'))
