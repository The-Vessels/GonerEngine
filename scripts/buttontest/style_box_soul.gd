@tool
class_name StyleBoxSoul extends StyleBox

@export var soul_offset = Vector2(-25.0, 10.0)
var soul_img: CompressedTexture2D = preload("res://assets/sprites/battle/soul.png")
var soul_rect: Rect2 = Rect2(soul_offset, Vector2(16.0, 16.0))

func _draw(to_canvas_item: RID, rect: Rect2) -> void:
	RenderingServer.canvas_item_add_texture_rect(
		to_canvas_item, soul_rect,
		soul_img.get_rid()
	)
