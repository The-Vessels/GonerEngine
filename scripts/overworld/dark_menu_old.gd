extends ColorRect

var btn := 0
enum {
	BTN_ITEM,
	BTN_EQUIP,
	BTN_TECH,
	BTN_CONF,
	BTN_NUM
}

func get_btn(idx: int) -> AnimatedSprite2D:
	return get_child(idx + 1)

func _input(event: InputEvent) -> void:
	var old_btn := btn
	if event.is_action_pressed('right'):
		btn = posmod(btn + 1, BTN_NUM)
	if event.is_action_pressed('left'):
		btn = posmod(btn - 1, BTN_NUM)
	
	if old_btn != btn:
		get_btn(old_btn).frame = old_btn
		get_btn(btn).frame = btn + 8
