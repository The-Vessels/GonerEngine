extends Control

@onready var dark_item_btn: TextureButton = $DarkMenuBtnContainer/DarkItemBtn
@onready var dark_menu_btn_container: HBoxContainer = $DarkMenuBtnContainer

func _ready():
	dark_item_btn.grab_focus.call_deferred()
	for child: TextureButton in dark_menu_btn_container.get_children():
		child.focus_exited.connect(func(): Global.play_ui_sound('menumove'))
		child.pressed.connect(func(): Global.play_ui_sound('select'))
