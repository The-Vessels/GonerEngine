@tool
extends Control

@export var the_font: Font
@export_tool_button("Redraw") var redraw_btn = queue_redraw

var chars = []

func _process(_delta: float) -> void:
	# queue_redraw()
	pass

func _draw():
	for ch in chars:
		RenderingServer.free_rid(ch)
	
	var item := get_canvas_item()
	var font := the_font
	var font_size := 16
	
	do_something_crazy(font, font_size)
	
	#var ch := make_char(font, font_size, "m")
	#RenderingServer.canvas_item_set_parent(ch, item)
	#chars.append(ch)

func draw_texture_color(
	item: RID, pos: Vector2, texture: RID, texture_size: Vector2, src_rect: Rect2,
	color_tl: Color, color_tr: Color, color_br: Color, color_bl: Color
):
	var indices := PackedInt32Array([0, 1, 2, 2, 3, 0])
	var colors := PackedColorArray([color_tl, color_tr, color_br, color_bl])
	
	var dst_size := src_rect.size
	var pos_tl := pos
	var pos_tr := pos + Vector2(1.0, 0.0) * dst_size
	var pos_br := pos + Vector2(1.0, 1.0) * dst_size
	var pos_bl := pos + Vector2(0.0, 1.0) * dst_size
	var points := PackedVector2Array([pos_tl, pos_tr, pos_br, pos_bl])
	
	var uv_pos := src_rect.position / texture_size
	var uv_size := src_rect.size / texture_size
	var uv_tl := uv_pos
	var uv_tr := uv_pos + Vector2(1.0, 0.0) * uv_size
	var uv_br := uv_pos + Vector2(1.0, 1.0) * uv_size
	var uv_bl := uv_pos + Vector2(0.0, 1.0) * uv_size
	var uvs := PackedVector2Array([uv_tl, uv_tr, uv_br, uv_bl])
	
	RenderingServer.canvas_item_add_triangle_array(
		item, indices, points, colors, uvs,
		PackedInt32Array(), PackedFloat32Array(), texture
	)

func get_top_and_bottom_colors(
	glyph_offset: Vector2, glyph_size: Vector2,
	font_size: int, tcolor: Color, bcolor: Color
) -> Array[Color]:
	var font_height := font_size
	var ystart := font_height + glyph_offset.y
	var yend := ystart + glyph_size.y
	var top_color: Color = lerp(tcolor, bcolor, ystart / font_height)
	var bot_color: Color = lerp(tcolor, bcolor, yend / font_height)
	return [top_color, bot_color]

func my_draw_char(char: String, font: Font, font_size: int, pos: Vector2) -> void:
	var ts := TextServerManager.get_primary_interface()
	var font_rid := font.get_rids()[0] # Apparently font.get_rid() is not valid. You MUST use font.get_rids().
	var glyph := ts.font_get_glyph_index(font_rid, font_size, ord(char), 0)
	var font_size_vec := Vector2i(font_size, 0)
	
	var glyph_offset := ts.font_get_glyph_offset(font_rid, font_size_vec, glyph)
	#glyph_offset.y += font.get_ascent(font_size)
	print('GLYPH OFFSET OF ', char, ': ', glyph_offset)
	var glyph_rect := ts.font_get_glyph_uv_rect(font_rid, font_size_vec, glyph)
	var glyph_tex := ts.font_get_glyph_texture_rid(font_rid, font_size_vec, glyph)
	var glyph_tex_size := ts.font_get_glyph_texture_size(font_rid, font_size_vec, glyph)
	
	var colors := get_top_and_bottom_colors(
		glyph_offset, glyph_rect.size, font_size, Color.RED, Color.BLUE
	)
	
	draw_texture_color(
		get_canvas_item(), pos + glyph_offset, glyph_tex, glyph_tex_size, glyph_rect,
		colors[0], colors[0], colors[1], colors[1]
	)

func do_something_crazy(font: Font, font_size: int) -> void:
	var string := 'Delta,|.'
	var pos := Vector2.ZERO
	var advance := 10
	for char in string:
		my_draw_char(char, font, font_size, pos)
		pos.x += font.get_char_size(ord(char), font_size).x

func make_char(font: Font, font_size: int, character: String) -> RID:
	var font_height := font.get_height(font_size)
	var item := RenderingServer.canvas_item_create()
	
	var letter := RenderingServer.canvas_item_create()
	font.draw_char(letter, Vector2(0, font_height), ord(character), font_size, Color.RED)
	RenderingServer.canvas_item_set_parent(letter, item)
	# RenderingServer.canvas_item_
	
	var shadow := RenderingServer.canvas_item_create()
	font.draw_char(shadow, Vector2(0, font_height) + Vector2.ONE, ord(character), font_size, Color.BLUE)
	RenderingServer.canvas_item_set_parent(shadow, item)
	RenderingServer.canvas_item_set_z_as_relative_to_parent(shadow, true)
	RenderingServer.canvas_item_set_z_index(shadow, -1)
	
	return item
