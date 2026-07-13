class_name NavSoul extends TextureRect
## A soul icon for [SoulButton] navigation

static var target_position: Vector2
static var instance: NavSoul
## How fast the soul moves to the targetted button (1.0 is instant)
@export_range(0.0, 1.0, 0.01) var lerp_weight: float = 1.0

const soul_img: CompressedTexture2D = preload("uid://dfv5tvlj53h6v")
const small_soul_img: CompressedTexture2D = preload("uid://d0gvyfnxs5o8w")
const soul_images: Dictionary = {
	"normal": soul_img,
	"small": small_soul_img
}
@export_enum("normal", "small") var soul_image: String = "normal"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self
	texture = soul_images.get(soul_image)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	instance.global_position = instance.global_position.lerp(target_position, lerp_weight)
