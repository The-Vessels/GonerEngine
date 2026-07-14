@icon("uid://06bcfmflya6n")
@tool
class_name SoulButton extends Button
## A button that uses a soul sprite for navigation

@export var soul_offset := Vector2(-14.0, 4.0)

const soul_img: CompressedTexture2D = preload("uid://dfv5tvlj53h6v")
const small_soul_img: CompressedTexture2D = preload("uid://d0gvyfnxs5o8w")

const soul_images: Dictionary = {
	"normal": soul_img,
	"small": small_soul_img,
	"none": null
}
@export_enum("normal", "small", "none") var soul_image: String = "normal"

## How fast the soul moves to the targetted button (1.0 is instant)
@export_range(0.0, 1.0, 0.01) var lerp_weight: float = 1.0

#@export var force_soul: bool = false

enum NavDirs {BOTH, UP_AND_DOWN, LEFT_AND_RIGHT}
@export var navigation_direction: NavDirs = NavDirs.BOTH

static var soul_node: TextureRect

static var soul_pos: Vector2
static var target_pos: Vector2

func _ready() -> void:
	#soul_node = TextureRect.new()
	#soul_node.position += soul_offset
	#soul_node.visible = false
	#add_child(soul_node)
	
	focus_entered.connect(func():
		soul_node = TextureRect.new()
		soul_node.texture = soul_images.get(soul_image)
		
		add_child(soul_node)
		if !soul_pos:
			soul_node.global_position = self.global_position + soul_offset
		else:
			soul_node.global_position = soul_pos
		target_pos = global_position + soul_offset
		
		#NavSoul.target_position = global_position + soul_offset
	)
	focus_exited.connect(func():
		soul_pos = soul_node.global_position
		remove_child.call_deferred(soul_node)
	)
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
	if soul_node:
		soul_node.global_position = lerp(soul_node.global_position, target_pos, lerp_weight)
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
