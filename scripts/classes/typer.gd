@tool
class_name Typer extends Control

var silent_chars: Array[String] = [" ", "^", "!", ".", "?", ",", ":", "/", "\\", "|", "*", "\n"]
var current_char: String

var caller: Node
var destroy_caller := true

var pause: int
var animating := false

var tag_content: String = ""
var text_effects: Array[String] = []
var time: int = 0
var text_gap := Vector2(8.0, 0.0)
var line_height: int = 18
var max_line_chars: int
var text_lines: PackedStringArray = []

var write_condition: bool:
	get:
		return (pause <= 0.0)

var typer_shader: TyperShader = null

@export var redraw: bool = false:
	set(val):
		if Engine.is_editor_hint():
			queue_redraw()

@export var text_index: int = 0:
	set(new):
		text_index = new
		if Engine.is_editor_hint():
			prepare_lines()
			queue_redraw()
@export_multiline("monospace") var text: Array[String] = [""]:
	set(new):
		text = new
		if Engine.is_editor_hint():
			text = new
			prepare_lines()
			queue_redraw()
			visible_characters = get_parsed_text().length()

@export var font_size: int = 16:
	set(new):
		font_size = new
		if Engine.is_editor_hint():
			font_size = new
			prepare_spacing()
			queue_redraw()

var _visible_characters := -1
@export var visible_characters := -1:
	get:
		return _visible_characters
	set(new):
		_visible_characters = new
		
@export_range(0.0, 1.0) var visible_ratio: float = 1.0:
	get:
		if _visible_characters == -1:
			return 1.0
		return _visible_characters / float(get_parsed_text().length())
	set(new):
		if new == 1.0:
			_visible_characters = -1
			return
		if new == 0.0:
			_visible_characters = 0
			return
		
		var clamped_ratio = clampf(new, 0.0, 1.0)
		_visible_characters = roundi(clamped_ratio * get_parsed_text().length())

@export_group("Talking Sound")
@export var talk_sounds: Array[AudioStream]
@export_subgroup("Random Pitch Range")
@export_range(-1, 0, 0.1) var lower_range: float = 0.0
@export_range(0, 1, 0.1) var upper_range: float = 0.0

# Gets the text without bbcode or commands
func get_parsed_text() -> String:
	var regex = RegEx.new()
	regex.compile("\\[.*?\\]")
	var text_without_tags = regex.sub(text[text_index], "", true)
	regex.compile("\\{.*?\\}")
	text_without_tags = regex.sub(text_without_tags, "", true)
	return text_without_tags

func add_linebreaks():
	var new_text_lines: PackedStringArray = []
	for line in text_lines:
		var char_count := 0
		var start_pos := 0
		var last_space_pos := 0
		var tag_mode := false
		var break_text = line.c_unescape()
		for i in break_text.length():
			var char_index = start_pos + char_count
			var char = break_text[char_index]
			#print(char_count," ", start_pos," ", last_space_pos, " ", max_line_chars, " ",char_index," ", break_text.length(), " ", char)
			
			if char == "[" or char == "{":
				tag_mode = true
				start_pos += 1
				continue
			if char == "]" or char == "}":
				tag_mode = false
				start_pos += 1
				continue
			if tag_mode:
				start_pos += 1
				continue
			
			if char_count+1 > max_line_chars:
				break_text[last_space_pos] = "\n"
				start_pos += max_line_chars
				char_count = 0
			if char == " ":
				last_space_pos = char_index
				
			char_count += 1
		new_text_lines.append_array(break_text.c_escape().split("\\n"))
	text_lines = new_text_lines

func prepare_lines():
	var commanded_text = parse_commands()
	text_lines = commanded_text.c_escape().split("\\n")
	for i in text_lines.size():
		text_lines.set(i, text_lines.get(i).c_unescape())
	add_linebreaks()
	
func prepare_spacing():
	text_gap = Vector2(font_size/2, 0.0)
	# thx sixtyfive for this cool maths
	max_line_chars = floor(self.size.x / text_gap.x)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	prepare_spacing()
	prepare_lines()
	queue_redraw()
	
	self.resized.connect(
		func():
			prepare_lines()
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	max_line_chars = floor(self.size.x / text_gap.x)
	queue_redraw()
	
	if Engine.is_editor_hint() or !is_node_ready():
		return
	
	time += 1
	
	if Input.is_action_just_pressed("confirm") and !animating:
		text_index += 1
		if text_index >= text.size():
			queue_free()
			return
		
		prepare_lines()
		visible_ratio = 0.0
	
	if animating and Input.is_action_just_pressed("cancel"):
		visible_ratio = 1.0
	
	if !(visible_ratio >= 1.0):
		animating = true
		if write_condition:
			write_char()
	else:
		animating = false
	
	if pause > 0: pause -= 1

func _draw() -> void:
	#print("FONT SIZE IS 16, FONT HEIGHT IS ", get_theme_default_font().get_height())
	if typer_shader == null:
		typer_shader = TyperShader.new(self)
	typer_shader.clear()
	
	text_effects.clear()
	var canvas = self.get_canvas_item()
	
	var asterisk: bool = false
	var current_line_asterisk: bool = false
	var char := 0
	var total_chars := 0
	var display_chars := 0
	var effect_mode: bool = false
	var is_closing_tag: bool = false
	
	# the position where the top left of the text should start
	var pos := Vector2(0, 0 + font_size)
	
	# loop through each line in text_lines
	for j in text_lines.size():
		var line: String = text_lines.get(j)
		
		# loop over each character in the line
		for i in line.length():
			if visible_characters > -1 and display_chars >= visible_characters:
				break
				
			var ch = line[i]
			total_chars += 1
			
			if ch == "[":
				# check if there's actually a closing bracket left in the text
				if text[text_index].find("]", total_chars) > -1:
					effect_mode = true
					if line[i+1] == "/":
						text_effects.pop_back()
						is_closing_tag = true
					continue
			if ch == "]":
				effect_mode = false
				if is_closing_tag:
					is_closing_tag = false
					continue
				text_effects.append(tag_content)
				tag_content = ""
				continue
			if effect_mode:
				if !is_closing_tag:
					tag_content += ch
				continue
			
			# if current char is first char in processing line and is an asterisk
			# and there haven't been any asterisks so far then turn on asterisk mode
			# and mark currently processing line as having the asterisk
			if char == 0 and ch == "*" and !asterisk:
				asterisk = true
				current_line_asterisk = true
			
			# if current char is first char in processing line
			# and asterisk exists anywhere in the text and it's not in the currently processing line
			# then add the offset unless the first char is also an asterisk
			if char == 0 and asterisk and !current_line_asterisk and ch != "*":
				char = 2
			
			var typer_char = Char.new(
				get_theme_default_font(),
				pos + (text_gap * char),
				Vector2(0.0, 0.0),
				ch,
				font_size
			)
			typer_char = apply_effects(typer_char, text_effects)
			
			#typer_shader.draw_char(
				#typer_char.font,
				#typer_char.pos + typer_char.pos_offset,
				#typer_char.glyph,
				#typer_char.font_size,
				#typer_char.color
			#)
			var color_top: Color
			var color_bottom: Color
			var shad_color_top: Color
			var shad_color_bottom: Color
			
			if typer_char.color == Color.WHITE:
				color_top = Color.WHITE
				color_bottom = Color.WHITE
				shad_color_top = Colors.c_dkgray
				shad_color_bottom = Colors.c_navy
			else:
				color_top = Color.WHITE
				color_bottom = typer_char.color
				var shadow_color: Color = lerp(Color.BLACK, typer_char.color, 0.3)
				shad_color_top = shadow_color
				shad_color_bottom = shadow_color
			
			draw_char_color(
				typer_char.font,
				typer_char.pos + typer_char.pos_offset + Vector2.ONE,
				typer_char.glyph,
				typer_char.font_size,
				shad_color_top, shad_color_bottom
			)
			
			draw_char_color(
				typer_char.font,
				typer_char.pos + typer_char.pos_offset,
				typer_char.glyph,
				typer_char.font_size,
				color_top, color_bottom
			)
			
			char += 1
			display_chars += 1
			if visible_characters > -1 and display_chars >= visible_characters:
				break
		
		# manually increment display_chars after each line to mimic newline chars
		display_chars += 1
		if visible_characters > -1 and display_chars >= visible_characters:
				break
		
		current_line_asterisk = false
		# pos.y += font_size
		pos.y += line_height
		pos.x = 0.0
		char = 0
	
	#typer_shader.draw()
	#typer_shader.test_draw()

class CommandInfo:
	var index: int
	var command: String
	func _init(idx: int, cmd: String):
		index = idx
		command = cmd

# Literally just for command parsing
func remove_bbcode(txt: String) -> String:
	var regex = RegEx.new()
	regex.compile("\\[.*?\\]")
	var text_without_tags = regex.sub(txt, "", true)
	return text_without_tags
	
var commands: Array[CommandInfo] = []
# Gets all the commands inside the dia text and adds them to the list of commands
# while also removing them from the commanded_text
# (the var name is kinda a misnomer since it's getting cleaned of the commands)
func parse_commands() -> String:
	var commanded_text = text[text_index]
	commands.clear()
	while true:
		# find the index of where the command starts (break the loop if it doesnt find any more)
		var left_index = remove_bbcode(commanded_text).findn("{")
		if left_index == -1: break
		# find the index of where the command ends (break the loop if it doesnt find any more)
		var right_index = remove_bbcode(commanded_text).findn("}", left_index)
		if right_index == -1: break
		
		var tag_content = remove_bbcode(commanded_text).substr(left_index+1, right_index-1-left_index)
		
		# erase the command from the dialogue text
		commanded_text = commanded_text.erase(commanded_text.findn("{"+tag_content+"}"), right_index+1-left_index)
		
		var command = CommandInfo.new(left_index, tag_content)
		commands.append(command)
	return commanded_text

func evaluate(command, variable_names = [], variable_values = []) -> void:
	var expression = Expression.new()
	var error = expression.parse(command)
	if error != OK:
		#push_error(expression.get_error_text())
		return
	
	var result = expression.execute([], self)
	
	if not expression.has_execute_failed() and result:
		print(str(result))
	
	commands.remove_at(0)

func wait(frames: int) -> void:
	pause = frames

func write_char():	
	# Check if the index of the char you're about to write has a command queued for it
	if commands:
		if visible_characters == commands[0].index:
			evaluate(commands[0].command)
	if write_condition:
		visible_characters += 1
		current_char = get_parsed_text()[visible_characters-1]
		if !silent_chars.has(current_char):
			play_talk_sound()

func play_talk_sound():
	var sound = talk_sounds.pick_random()
	var pitch_offset = randf_range(lower_range, upper_range)
	var player = AudioStreamPlayer.new()
	player.stream = sound
	player.pitch_scale += pitch_offset
	player.finished.connect(
		func():
			player.queue_free()
	)
	add_child(player)
	player.play()

## All data for a character being written in the typer
class Char extends RefCounted:
	var glyph: String
	var pos: Vector2
	var pos_offset: Vector2
	var color: Color
	var font: Font
	var font_size: int
	func _init(_font: Font, _pos: Vector2, _pos_offset: Vector2, _glyph: String, _font_size: int, _color: Color = Color(1.0, 1.0, 1.0, 1.0)) -> void:
		font = _font
		pos = _pos
		pos_offset = _pos_offset
		glyph = _glyph
		font_size = _font_size
		color = _color

## Returns a given char after all active effects have been applied to it
func apply_effects(typer_char: Char, effects: Array[String]) -> Char:
	for effect in text_effects:
		# String.split returns a PackedStringArray so we convert it into an Array[String] for convenience
		var split_tag: Array[String] = Array(Array(effect.split(" ")), TYPE_STRING, "", null)
		
		var effect_name = split_tag[0]
		
		# Make a dictionary of OptionName:OptionValue
		var tag_options: Dictionary = {}
		for i in range(1, split_tag.size()):
			var param = split_tag[i]
			var value_pos = param.find("=")
			if value_pos > -1:
				tag_options[param.substr(0, value_pos)] = param.substr(value_pos + 1)
		
		var effect_value
		# If the effect's name has a value, remove it from the name and add it to tag_options
		var main_value_pos = effect_name.find("=")
		if main_value_pos > -1:
			effect_value = effect_name.substr(main_value_pos + 1)
			effect_name = effect_name.substr(0, main_value_pos)
			tag_options[effect_name] = effect_value
		
		var effecter = typer_effects_registry.get(effect_name)
		if effecter:
			typer_char = effecter.effect_char(typer_char, tag_options, time)
	return typer_char

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

func draw_char_color(
	font: Font, pos: Vector2, chara: String, font_size: int,
	color_top: Color, color_bottom: Color
) -> void:
	var ts := TextServerManager.get_primary_interface()
	var font_rid := font.get_rids()[0] # Apparently font.get_rid() is not valid. You MUST use font.get_rids().
	var glyph := ts.font_get_glyph_index(font_rid, font_size, ord(chara), 0)
	var font_size_vec := Vector2i(font_size, 0)
	var ascent_vec := Vector2(0.0, font.get_ascent(font_size))
	
	var glyph_offset := ts.font_get_glyph_offset(font_rid, font_size_vec, glyph)
	# print('GLYPH OFFSET OF ', char, ': ', glyph_offset)
	var glyph_rect := ts.font_get_glyph_uv_rect(font_rid, font_size_vec, glyph)
	var glyph_tex := ts.font_get_glyph_texture_rid(font_rid, font_size_vec, glyph)
	var glyph_tex_size := ts.font_get_glyph_texture_size(font_rid, font_size_vec, glyph)
	
	var colors := get_top_and_bottom_colors(
		glyph_offset, glyph_rect.size, font_size, color_top, color_bottom
	)
	
	draw_texture_color(
		get_canvas_item(), pos + glyph_offset + ascent_vec,
		glyph_tex, glyph_tex_size, glyph_rect,
		colors[0], colors[0], colors[1], colors[1]
	)

## Dictionary to register every effect
static var typer_effects_registry: Dictionary = {
	"color": ColorTyperEffect.new(),
	"shake": ShakeTyperEffect.new()
}
