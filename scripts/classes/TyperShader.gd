class_name TyperShader extends RefCounted

const DARKTEXTBOX_SHADER_UID := "uid://djokdi5qbrote"

var canvas_item: RID
var viewport_size: Vector2
var font_height: int
var line_height: int
var enable_shader: bool = true

var text_viewport: RID
var text_canvas: RID
var text_canvas_item: RID

var shad_num: int = 0
var shad_viewports: Array[RID]
var shad_canvases: Array[RID]
var shad_canvas_items: Array[RID]
var shad_materials: Array[ShaderMaterial]

func _init(typ: Typer) -> void:
	canvas_item = typ.get_canvas_item()
	viewport_size = typ.size
	font_height = typ.font_size
	line_height = typ.line_height

	init()

func init() -> void:
	shad_num = 0
	set_text_uids()
	add_shader(load(DARKTEXTBOX_SHADER_UID))

func resize_viewport(viewport: RID) -> void:
	RenderingServer.viewport_set_size(viewport, ceil(viewport_size.x), ceil(viewport_size.y))

func resize_all_viewports() -> void:
	resize_viewport(text_viewport)
	for shad_viewport in shad_viewports:
		resize_viewport(shad_viewport)

func set_shader_params(idx: int) -> void:
	shad_materials[idx].set_shader_parameter("line_height", line_height)
	shad_materials[idx].set_shader_parameter("font_height", font_height)
	shad_materials[idx].set_shader_parameter("enable", enable_shader)

func set_text_uids() -> void:
	var rid_arr := make_drawing_rids()
	text_viewport = rid_arr[0]
	text_canvas = rid_arr[1]
	text_canvas_item = rid_arr[2]

func add_shader(shader: Shader) -> void:
	var mat := ShaderMaterial.new()
	mat.shader = shader
	var rid_arr := make_drawing_rids(mat)
	
	shad_viewports.resize(shad_num + 1)
	shad_canvases.resize(shad_num + 1)
	shad_canvas_items.resize(shad_num + 1)
	shad_materials.resize(shad_num + 1)
	
	shad_viewports[shad_num] = rid_arr[0]
	shad_canvases[shad_num] = rid_arr[1]
	shad_canvas_items[shad_num] = rid_arr[2]
	shad_materials[shad_num] = mat
	
	set_shader_params(shad_num)
	shad_num += 1

# Returns viewport, canvas, and canvas_item
func make_drawing_rids(shader_material: ShaderMaterial = null) -> Array[RID]:
	var viewport := RenderingServer.viewport_create()
	resize_viewport(viewport)
	RenderingServer.viewport_set_active(viewport, true)
	RenderingServer.viewport_set_update_mode(viewport, RenderingServer.VIEWPORT_UPDATE_ALWAYS)
	RenderingServer.viewport_set_transparent_background(viewport, true)
	
	var canvas := RenderingServer.canvas_create()
	RenderingServer.viewport_attach_canvas(viewport, canvas)
	
	var item := RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(item, canvas)
	
	if shader_material != null:
		RenderingServer.canvas_item_set_material(item, shader_material.get_rid())
	
	return [viewport, canvas, item]

func clear() -> void:
	if not text_canvas_item.is_valid():
		init()
		
	RenderingServer.canvas_item_clear(text_canvas_item)

func draw_char(
	font: Font,
	pos: Vector2,
	character: String,
	font_size: int = 16,
	modulate: Color = Color.WHITE
) -> void:
	if not text_canvas_item.is_valid():
		init()
	
	font.draw_char(text_canvas_item, pos, ord(character), font_size, modulate)

func draw() -> void:
	print('DRAW BEGIN')
	var dst_rect := Rect2(Vector2.ZERO, viewport_size)
	
	for i in range(shad_num):
		var src_viewport: RID
		if i == 0:
			src_viewport = text_viewport
		else:
			src_viewport = shad_viewports[i - 1]
		var src_texture := RenderingServer.viewport_get_texture(src_viewport)
		
		set_shader_params(i)
		RenderingServer.canvas_item_clear(shad_canvas_items[i])
		RenderingServer.canvas_item_add_texture_rect(shad_canvas_items[i], dst_rect, src_texture)
	
	var shad_final_viewport := shad_viewports[shad_num - 1] if shad_num > 0 else text_viewport
	var shad_final_texture := RenderingServer.viewport_get_texture(shad_final_viewport)
	RenderingServer.canvas_item_add_texture_rect(canvas_item, dst_rect, shad_final_texture)
	print('DRAW END')

func test_draw() -> void:
	RenderingServer.canvas_item_add_circle(canvas_item, Vector2.ZERO, 20.0, Color.GREEN)
