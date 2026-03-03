extends Control
@onready var darkcontroller: Control = $"."
@onready var dark_menu_btn_container: HBoxContainer = $TopRect/DarkMenuBtnContainer
@onready var dark_item_btn: TextureButton = $TopRect/DarkMenuBtnContainer/DarkItemBtn
@onready var dark_item_menu: Control = $TopRect/DarkMenuBtnContainer/DarkItemBtn/DarkItemMenu
@onready var top_rect: ColorRect = $TopRect
@onready var bottom_rect: ColorRect = $BottomRect
const CONFIG_H = preload("uid://c7xa7pmx162nx")

var menuOpen := false

func _ready():
	dark_menu_btn_container.get_child(0).grab_focus.call_deferred()
	for child: TextureButton in dark_menu_btn_container.get_children():
		child.focus_exited.connect(
			func():
				Global.play_ui_sound('menumove')
		)
		child.pressed.connect(
			func():
				Global.play_ui_sound('select')
				child.get_child(0).visible = true
				child.get_child(0).get_child(0).grab_focus.call_deferred()
		)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu", false) && menuOpen == false:
		top_rect.position.y += top_rect.size.y
		bottom_rect.position.y -= bottom_rect.size.y
		menuOpen = true
	elif event.is_action_pressed("menu", false) && menuOpen == true:
		top_rect.position.y -= top_rect.size.y
		bottom_rect.position.y += bottom_rect.size.y
		menuOpen = false
