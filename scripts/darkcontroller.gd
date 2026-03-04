extends Control
@onready var darkcontroller: Control = $"."
@onready var dark_menu_btn_container: HBoxContainer = $TopRect/DarkMenuBtnContainer
@onready var dark_item_btn: TextureButton = $TopRect/DarkMenuBtnContainer/DarkItemBtn
@onready var dark_item_menu: Control = $TopRect/DarkMenuBtnContainer/DarkItemBtn/DarkItemMenu
@onready var top_rect: ColorRect = $TopRect
@onready var bottom_rect: ColorRect = $BottomRect

const CONFIG_H = preload("uid://c7xa7pmx162nx")

func _ready():
	dark_menu_btn_container.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_DISABLED
	
func _process(delta: float) -> void:
	for child in bottom_rect.get_children(false):
		if child.get_index() == Global.currentHero:
			child.isCurrentChar = true
		else:
			child.isCurrentChar = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu", false) && Global.darkMenuOpened == false:
		top_rect.position.y += top_rect.size.y
		bottom_rect.position.y -= bottom_rect.size.y
		dark_menu_btn_container.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_ENABLED
		dark_menu_btn_container.get_child(Global.selectedBtn).grab_focus()
		Global.darkMenuOpened = true
	elif (event.is_action_pressed("menu", false) || event.is_action_pressed("cancel", false)) && Global.darkMenuOpened == true:
		top_rect.position.y -= top_rect.size.y
		bottom_rect.position.y += bottom_rect.size.y
		dark_menu_btn_container.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_DISABLED
		Global.darkMenuOpened = false
	elif event.is_action_pressed("right"):
		Global.currentHero += 1
	elif event.is_action_pressed("left"):
		Global.currentHero -= 1
