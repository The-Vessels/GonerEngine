@icon("uid://06bcfmflya6n")
@tool
class_name SoulButton extends Button
## A button that uses a soul sprite for navigation

## The offset of the soul node in pixels from it's default position.
@export var soul_offset: Vector2 = Vector2(0.0, 0.0)

const soul_img: CompressedTexture2D = preload("uid://dfv5tvlj53h6v")
const small_soul_img: CompressedTexture2D = preload("uid://d0gvyfnxs5o8w")
const soul_images: Dictionary = {
	"normal": soul_img,
	"small": small_soul_img,
	"none": null
}
## Which soul sprite to use for the button.
## "normal" is the one usually used in the dark world,
## and "small" is the usually used in the light world.
## [br][br]
## [b]Note:[/b] the small soul is almost half the size of the normal soul sprite,
## so you might find yourself needing to also change the [member SoulButton.soul_scale].
@export_enum("normal", "small", "none") var soul_image: String = "normal"
static var soul_node: TextureRect

## The scale of the [member SoulButton.soul_image] node created for the SoulButton.
## [br][br]
## [b]Note:[/b] Doesn't actually set the [member Control.scale] property of the soul node.
## Rather, it is used as a multiplier for the [member Control.size] of the node.
@export_range(0.50, 2.00, 0.25) var soul_scale: float = 1.00

## How fast the soul moves to the targetted button (1.0 is instant)
@export_range(0.0, 1.0, 0.01) var move_speed: float = 1.0
static var lerp_weight: float

#@export var force_soul: bool = false

enum NavDirs {BOTH, UP_AND_DOWN, LEFT_AND_RIGHT}
@export var navigation_direction: NavDirs = NavDirs.BOTH


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
		
		if soul_image == "normal":
			soul_node.size = Vector2(16.0, 16.0)
		else:
			soul_node.size = Vector2(9.0, 9.0)
		soul_node.size *= Vector2(soul_scale, soul_scale)
			
		add_child(soul_node)
		
		if !soul_pos:
			soul_node.global_position = self.global_position + soul_offset
		else:
			soul_node.global_position = soul_pos
		
		var soul_to_right_x = self.global_position.x - soul_node.size.x
		var center_y = self.global_position.y + (self.size.y / 2) - (soul_node.size.y / 2)
		target_pos = Vector2(soul_to_right_x, center_y) + soul_offset
		
		lerp_weight = self.move_speed
		
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
