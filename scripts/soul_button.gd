@icon("uid://06bcfmflya6n")
@tool
class_name SoulButton extends Button

@export var soul_offset := Vector2(-14.0, 4.0)

const soul_img: CompressedTexture2D = preload("res://assets/sprites/ui/menu/menu_soul.png")
const button_theme = preload("res://assets/themes/buttontheme.tres")

var soul_node: TextureRect

func _ready() -> void:
	theme = button_theme
	
	soul_node = TextureRect.new()
	soul_node.texture = soul_img
	soul_node.position += soul_offset
	soul_node.visible = false
	
	add_child(soul_node)
	
	focus_entered.connect(func(): soul_node.visible = true)
	focus_exited.connect(func(): soul_node.visible = false)
	pressed.connect(func(): Global.play_ui_sound("select"))
