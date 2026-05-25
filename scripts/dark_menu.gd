extends Control
@onready var dark_menu_btn_container: HBoxContainer = $TopRect/DarkMenuBtnContainer
@onready var top_rect: ColorRect = $TopRect
@onready var bottom_panel: Panel = $BottomPanel
@onready var dark_menu_desc: AnimatedSprite2D = $TopRect/DarkMenuDescContainer/DarkMenuDesc
@onready var dark_submenu_container: Control = $DarkSubmenuContainer

var menu_options: Array[Node]

var menutrans := 0.0
var close := false

var current_option := 0
var menu_open := false
var submenu_open := false

func _ready():
	menu_options = dark_menu_btn_container.get_children()
	menu_options[current_option].grab_focus()
	
	for option_button: TextureButton in dark_menu_btn_container.get_children():
		option_button.focus_entered.connect(
			func():
				current_option = option_button.get_index()
				if menu_open:
					Global.play_ui_sound("menumove")
		)
		option_button.pressed.connect(
			func():
				if !menu_open:
					return
				Global.play_ui_sound("select")
		)

func _process(delta: float) -> void:
	dark_menu_desc.frame = current_option
	
	menutrans = lerpf(menutrans, (1.0 if menu_open else 0.0), (delta * 30) * 0.4)
	var menuoffset = snappedf(menutrans, 0.01) * 80.0
	
	if snappedf(menutrans, 0.01) < 0.1:
		visible = false
	
	top_rect.position.y = menuoffset - top_rect.size.y
	bottom_panel.position.y = (480 + (top_rect.size.y - bottom_panel.size.y)) - menuoffset
	
	if Input.is_action_just_pressed("cancel"):
		if menu_open:
			if !submenu_open:
				disable_unfocused_options()
				menu_open = false
			else:
				pass
	
	if Input.is_action_just_pressed("menu"):
		if menu_open:
			if !submenu_open:
				disable_unfocused_options()
				menu_open = false
		else:
			visible = true
			enable_all_options()
			menu_open = true
			
			
func disable_unfocused_options() -> void:
	for button: TextureButton in dark_menu_btn_container.get_children():
		if !button.has_focus():
			button.focus_mode = Control.FOCUS_NONE
			
func enable_all_options() -> void:
	for button: TextureButton in dark_menu_btn_container.get_children():
		button.focus_mode = Control.FOCUS_ALL


func _on_visibility_changed() -> void:
	if !is_node_ready():
		return
	
	if visible:
		enable_all_options()
		menu_options[current_option].grab_focus()
	else:
		disable_unfocused_options()
