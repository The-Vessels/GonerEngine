extends Control
@onready var darkcontroller: Control = $"."
@onready var dark_menu_btn_container: HBoxContainer = $TopRect/DarkMenuBtnContainer
@onready var dark_item_btn: TextureButton = $TopRect/DarkMenuBtnContainer/DarkItemBtn
@onready var dark_item_menu: Control = $TopRect/DarkMenuBtnContainer/DarkItemBtn/DarkItemMenu
@onready var top_rect: ColorRect = $TopRect
@onready var bottom_panel: Panel = $BottomPanel
@onready var dark_menu_desc: AnimatedSprite2D = $TopRect/DarkMenuDescContainer/DarkMenuDesc
@onready var dark_submenu_container: Control = $DarkSubmenuContainer

var menutrans := 0.0
var close := false

var current_option := 0
var menu_open := false
var submenu_open := false

func _ready():	
	for option_button: TextureButton in dark_menu_btn_container.get_children():
		option_button.focus_entered.connect(
			func():
				if menu_open:
					Global.play_ui_sound("menumove")
				current_option = option_button.get_index()
		)
		option_button.pressed.connect(
			func():
				Global.play_ui_sound("select")
		)

func _process(delta: float) -> void:
	dark_menu_desc.frame = current_option
	
	menutrans = lerpf(menutrans, (1.0 if menu_open else 0.0), 0.4)
	var menuoffset = snappedf(menutrans, 0.01) * 80.0
	
	visible == true if menutrans == 1.0 else false
	
	top_rect.position.y = menuoffset - top_rect.size.y
	bottom_panel.position.y = (480 + (top_rect.size.y - bottom_panel.size.y)) - menuoffset
	
	
	if Input.is_action_just_pressed("cancel"):
		if menu_open:
			if !submenu_open:
				menu_open = false
			else:
				pass
	
	if Input.is_action_just_pressed("menu"):
		if menu_open:
			if !submenu_open:
				menu_open = false
		else:
			dark_menu_btn_container.get_child(current_option).grab_focus()
			menu_open = true
