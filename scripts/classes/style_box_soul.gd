@tool
class_name StyleBoxSoul extends StyleBox

@export var soul_offset = Vector2(-14.0, 4.0)
var soul_img: CompressedTexture2D = preload("res://sprites/ui/menu/soul/menu_soul.png")
var soul_rect: Rect2 = Rect2(soul_offset, soul_img.get_size())

func _draw(to_canvas_item: RID, rect: Rect2) -> void:
	RenderingServer.canvas_item_add_texture_rect(
		to_canvas_item, soul_rect,
		soul_img.get_rid()
	)
