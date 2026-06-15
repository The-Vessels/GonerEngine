extends Control
@onready var options_container: HBoxContainer = $TopPanel/OptionsContainer
@onready var top_panel: Panel = $TopPanel
@onready var bottom_panel: Panel = $BottomPanel
@onready var menu_desc: AnimatedSprite2D = $TopPanel/MenuDesc
@onready var submenus: Control = $Submenus

var menu_options: Array[Node]

var menutrans := 0.0
var animating := false

var current_option := 0
var menu_open := false
var submenu_open := false

func _ready():
	menu_options = options_container.get_children()
	menu_options[current_option].grab_focus()
	
	# Set up option buttons
	for option_button: TextureButton in options_container.get_children():
		option_button.focus_entered.connect(
			func():
				current_option = option_button.get_index()
				if menu_open and !submenu_open:
					Global.play_ui_sound("menumove")
		)
		option_button.pressed.connect(
			func():
				if !menu_open:
					return
				Global.play_ui_sound("select")
				var option_submenu: Control = submenus.find_child(option_button.name)
				option_submenu.visible = true
		)
	
	# Set up submenus
	for submenu: Control in submenus.get_children():
		submenu.visibility_changed.connect(
			func():
				if submenu.visible:
					disable_all_options()
					submenu_open = true
					return
				else:
					Global.play_ui_sound("smallswing")
					enable_all_options()
					var option: TextureButton = options_container.find_child(submenu.name)
					option.grab_focus()
					option.button_pressed = false
					submenu_open = false
		)

func _process(delta: float) -> void:
	menu_desc.frame = current_option
	
	menutrans = lerpf(menutrans, (1.0 if menu_open else 0.0), (delta * 30) * 0.4)
	var menuoffset = snappedf(menutrans, 0.01) * 80.0
	
	if snappedf(menutrans, 0.01) == 0.0:
		visible = false
	
	if snappedf(menutrans, 0.01) < 0.1 or snappedf(menutrans, 0.01) > 0.9:
		animating = false
	else:
		animating = true
	
	top_panel.position.y = menuoffset - top_panel.size.y
	bottom_panel.position.y = (480 + (top_panel.size.y - bottom_panel.size.y)) - menuoffset
	
	if (Input.is_action_just_pressed("menu") or Input.is_action_just_pressed("cancel")) and !animating:
		if menu_open:
			if !submenu_open:
				disable_unfocused_options()
				menu_open = false
				Global.moveable = true
		else:
			if Input.is_action_just_pressed("menu"):
				visible = true
				enable_all_options()
				menu_open = true
				Global.moveable = false

# This is literally just needed so that the selected button is
# still focused when the menu is sliding out of view
# tldr: i hate this
func disable_unfocused_options() -> void:
	for button: TextureButton in options_container.get_children():
		if !button.has_focus():
			button.focus_mode = Control.FOCUS_NONE

func disable_all_options() -> void:
	for button: TextureButton in options_container.get_children():
		button.focus_mode = Control.FOCUS_NONE

func enable_all_options() -> void:
	for button: TextureButton in options_container.get_children():
		button.focus_mode = Control.FOCUS_ALL

func _on_visibility_changed() -> void:
	if !is_node_ready():
		return
	
	if visible:
		enable_all_options()
		menu_options[current_option].grab_focus()
	else:
		disable_unfocused_options()

# Disable echoing of input events
# so you can't hold down arrow keys to navigate
func _input(event: InputEvent) -> void:
	if event.is_echo():
		get_viewport().set_input_as_handled()
