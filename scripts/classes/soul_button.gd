@icon("uid://06bcfmflya6n")
@tool
class_name SoulButton extends Button
## A button that reveals a soul sprite when focused on

@export var soul_offset := Vector2(-14.0, 4.0)

#enum SoulImages {NONE, NORMAL_SOUL, SMALL_SOUL}
#@export var soul_image: SoulImages
#
#@export var force_soul: bool = false

enum NavDirs {BOTH, UP_AND_DOWN, LEFT_AND_RIGHT}
@export var navigation_direction: NavDirs = NavDirs.BOTH

#const soul_img: CompressedTexture2D = preload("uid://dfv5tvlj53h6v")
#const small_soul_img: CompressedTexture2D = preload("uid://d0gvyfnxs5o8w")
#
#var soul_node: TextureRect

func _ready() -> void:
	#soul_node = TextureRect.new()
	#soul_node.position += soul_offset
	#soul_node.visible = false
	#add_child(soul_node)
	
	focus_entered.connect(func():
		#soul_node.visible = false
		NavSoul.target_position = global_position + soul_offset
	)
	#focus_exited.connect(func(): soul_node.visible = false)
	pressed.connect(
		func():
			if !disabled:
				Global.play_ui_sound("select")
	)
	
	# Disable keyboard/gamepad navigation for certain directions
	# By setting those neighbors as the node itself
	match navigation_direction:
		NavDirs.UP_AND_DOWN:
			focus_neighbor_left = get_path()
			focus_neighbor_right = get_path()
		NavDirs.LEFT_AND_RIGHT:
			focus_neighbor_top = get_path()
			focus_neighbor_bottom = get_path()

func _process(delta: float) -> void:
	#match soul_image:
		#SoulImages.NONE:
			#soul_node.texture = null
		#SoulImages.NORMAL_SOUL:
			#soul_node.texture = soul_img
		#SoulImages.SMALL_SOUL:
			#soul_node.texture = small_soul_img
	
	#if force_soul:
		#soul_node.visible = true
	#elif !force_soul and !has_focus():
		#soul_node.visible = false
	pass
