extends Control

@onready var virtual_joystick: VirtualJoystick = $VirtualJoystick

var subviewport: SubViewport
var last_pressed_arr: Array[bool] = [false, false, false, false]
var action_names: Array[StringName] = ["up", "down", "right", "left"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.has_feature("mobile"):
		visible = true
	subviewport = get_node('../../BorderAndGame')

# Meant for correctly processing the joystick.
func _process(_delta: float) -> void:
	var v := Input.get_vector("joy_left", "joy_right", "joy_down", "joy_up")
	
	var angle := rad_to_deg(v.angle())
	var pressed_arr: Array[bool] = [false, false, false, false]
	
	if v.length() > $VirtualJoystick.deadzone_ratio:
		if angle > 22.5 and angle < 157.5:
			pressed_arr[0] = true
		elif angle < -22.5 and angle > -157.5:
			pressed_arr[1] = true
		
		if angle > -67.5 and angle < 67.5:
			pressed_arr[2] = true
		elif angle > 112.5 or angle < -112.5:
			pressed_arr[3] = true
	
	for i in range(4):
		var now := pressed_arr[i]
		var last := last_pressed_arr[i]
		if now and not last:
			Input.action_press(action_names[i])
			send_ui_event("ui_" + action_names[i], true)
		elif not now and last:
			Input.action_release(action_names[i])
			send_ui_event("ui_" + action_names[i], false)
	
	last_pressed_arr = pressed_arr

func send_ui_event(event_name: StringName, press: bool) -> void:
	if subviewport != null:
		var event := InputEventAction.new()
		event.action = event_name
		event.pressed = press
		subviewport.push_input(event)

func _on_confirm_button_pressed() -> void:
	send_ui_event(&"ui_accept", true)
func _on_confirm_button_released() -> void:
	send_ui_event(&"ui_accept", false)
func _on_cancel_button_pressed() -> void:
	send_ui_event(&"ui_cancel", true)
func _on_cancel_button_released() -> void:
	send_ui_event(&"ui_cancel", false)
