@icon("uid://06bcfmflya6n")
@tool
class_name SoulButton extends Button
## A button that reveals a soul sprite when focused on

@export var soul_offset := Vector2(-14.0, 4.0)

enum SoulImages {NONE, NORMAL_SOUL, SMALL_SOUL}
@export var soul_override: SoulImages

@export var force_soul: bool = false

const soul_img: CompressedTexture2D = preload("uid://dfv5tvlj53h6v")
const small_soul_img: CompressedTexture2D = preload("uid://d0gvyfnxs5o8w")

var soul_node: TextureRect

func _ready() -> void:
	soul_node = TextureRect.new()
	soul_node.texture = small_soul_img
	soul_node.position += soul_offset
	soul_node.visible = false
	
	add_child(soul_node)
	
	focus_entered.connect(func(): soul_node.visible = true)
	focus_exited.connect(func(): soul_node.visible = false)
	pressed.connect(
		func():
			if !disabled:
				Global.play_ui_sound("select")
	)

func _process(delta: float) -> void:
	if force_soul:
		soul_node.visible = true
	elif !force_soul and !has_focus():
		soul_node.visible = false
