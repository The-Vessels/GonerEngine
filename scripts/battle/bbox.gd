extends Control

var og_y := position.y
var og_h := size.y
var grow_size: float = 0.0
var is_selected: bool = false

func set_rect_grow_size(grow: float) -> void:
	var y := og_y + grow
	var h := og_h - grow
	position.y = y
	size.y = h

func animate_openclose(selected: bool, input: float, dt: float) -> float:
	var dtmult := 30 * dt
	var x := input
	if selected:
		if x > -32:
			x -= 2 * dtmult
		if x > -24:
			x -= 4 * dtmult
		if x > -16:
			x -= 6 * dtmult
		if x > -8:
			x -= 8 * dtmult
		if x < -32:
			x = -32
	else:
		if x < -14:
			x += 15 * dtmult
		else:
			x = 0
	return x

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	grow_size = animate_openclose(is_selected, grow_size, delta)
	set_rect_grow_size(grow_size)

func _on_button_pressed() -> void:
	is_selected = not is_selected
