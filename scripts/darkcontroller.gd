extends Control
@onready var darkcontroller: Control = $"."
@onready var dark_menu_btn_container: HBoxContainer = $TopRect/DarkMenuBtnContainer
@onready var dark_item_btn: TextureButton = $TopRect/DarkMenuBtnContainer/DarkItemBtn
@onready var dark_item_menu: Control = $TopRect/DarkMenuBtnContainer/DarkItemBtn/DarkItemMenu
@onready var top_rect: ColorRect = $TopRect
@onready var bottom_rect: ColorRect = $BottomRect
@onready var dark_menu_desc: Sprite2D = $TopRect/DarkMenuDescContainer/DarkMenuDesc

const ITEM = preload("uid://crc76dli0yory")
const EQUIP = preload("uid://daa65pt526k5b")
const POWER = preload("uid://grusm1sdsx3k")
const CONFIG = preload("uid://bivrq4li071wj")

var DarkBtnImgs = [
	ITEM,
	EQUIP,
	POWER,
	CONFIG,
]

func _ready():
	dark_menu_btn_container.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_DISABLED
	
func _process(delta: float) -> void:
	for child in bottom_rect.get_children(false):
		if child.get_index() == Global.currentHero:
			child.isCurrentHero = true
		else:
			child.isCurrentHero = false
	dark_menu_desc.texture = DarkBtnImgs[Global.selectedDarkBtn]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu", false) && Global.darkMenuOpened == false:
		top_rect.position.y += top_rect.size.y
		bottom_rect.position.y -= bottom_rect.size.y + 2 # +2 to account for charbox top line
		dark_menu_btn_container.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_ENABLED
		dark_menu_btn_container.get_child(Global.selectedDarkBtn).grab_focus()
		Global.darkMenuOpened = true
	elif (event.is_action_pressed("menu", false) || event.is_action_pressed("cancel", false)) && Global.darkMenuOpened == true:
		top_rect.position.y -= top_rect.size.y
		bottom_rect.position.y += bottom_rect.size.y + 2 # +2 to account for charbox top line
		dark_menu_btn_container.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_DISABLED
		Global.darkMenuOpened = false
	elif event.is_action_pressed("right") && Global.darkMenuOpened == true:
		Global.currentHero += 1
		if Global.currentHero >= bottom_rect.get_child_count(false):
			Global.currentHero = 0
	elif event.is_action_pressed("left") && Global.darkMenuOpened == true:
		Global.currentHero -= 1
		if Global.currentHero < 0:
			Global.currentHero = bottom_rect.get_child_count(false) - 1
