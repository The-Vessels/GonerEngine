extends Node2D

var currentIdx = 0
@onready var nButtons = get_child_count()

func get_btn(idx) -> AnimatedSprite2D:
	return get_child(idx)

func set_buttons(oldIdx, newIdx):
	get_btn(oldIdx).frame = oldIdx + 12
	get_btn(newIdx).frame = newIdx

func _ready():
	for i in range(nButtons):
		if i == currentIdx:
			get_btn(i).frame = i
		else:
			get_btn(i).frame = i + 12

func _input(event):
	if event.is_action_pressed('ui_right'):
		var oldIdx = currentIdx
		currentIdx += 1
		if currentIdx >= nButtons:
			currentIdx = 0
		set_buttons(oldIdx, currentIdx)
	elif event.is_action_pressed('ui_left'):
		var oldIdx = currentIdx
		currentIdx -= 1
		if currentIdx < 0:
			currentIdx = nButtons - 1
		set_buttons(oldIdx, currentIdx)
