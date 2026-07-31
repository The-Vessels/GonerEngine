@tool
class_name Typer extends Control

var tag_content: String = ""
var text_effects: Array[String] = []
var time: int = 0
var text_gap := Vector2(8.0, 0.0)
var max_line_chars: int
var text_lines: PackedStringArray = []
var text_words: Array[PackedStringArray] = []

@export_multiline("monospace") var text := "":
	set(new):
		text = new
		if Engine.is_editor_hint():
			text = new
			prepare_words()
			queue_redraw()

@export var font_size: int = 16:
	set(new):
		font_size = new
		if Engine.is_editor_hint():
			font_size = new
			prepare_spacing()
			queue_redraw()

@export var visible_characters := 0
@export_range(0.0, 1.0) var visible_ratio: float = 1.0

func add_linebreaks():
	var new_text_lines: PackedStringArray = []
	for line in text_lines:
		var char_count := 0
		var start_pos := 0
		var last_space_pos := 0
		var command_mode := false
		var break_text = line.c_unescape()
		for i in break_text.length():
			var char_index = start_pos + char_count
			var char = break_text[char_index]
			#print(char_count," ", start_pos," ", last_space_pos, " ", max_line_chars, " ",char_index," ", break_text.length(), " ", char)
			
			if char == "[":
				command_mode = true
				start_pos += 1
				continue
			if char == "]":
				command_mode = false
				start_pos += 1
				continue
			if command_mode:
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

func prepare_words():
	text_lines = text.c_escape().split("\\n")
	add_linebreaks()
	text_words.clear()
	for i in text_lines.size():
		text_lines.set(i, text_lines.get(i).c_unescape())
		text_words.append(text_lines.get(i).split(" "))
	
func prepare_spacing():
	text_gap = Vector2(font_size/2, 0.0)
	# thx sixtyfive for this cool maths
	max_line_chars = floor(self.size.x / text_gap.x)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	prepare_spacing()
	prepare_words()
	queue_redraw()
	
	self.resized.connect(
		func():
			prepare_words()
	)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	time += 1
	max_line_chars = floor(self.size.x / text_gap.x)
	queue_redraw()
	
	# really basic typing functionality
	if visible_characters > -1 and visible_characters < text.length():
		visible_characters += 1
		visible_ratio = visible_characters / float(text.length())
		

func _draw() -> void:
	text_effects.clear()
	var canvas = self.get_canvas_item()
	
	var asterisk: bool = false
	var current_line_asterisk: bool = false
	var char := 0
	var total_chars := 0
	var display_chars := 0
	var command_mode: bool = false
	var is_closing_tag: bool = false
	
	# the position where the top left of the text should start
	var pos := Vector2(0, 0 + font_size)
	# loop through each word in text_words
	for k in text_words.size():
		var line = text_words.get(k)
		
		for j in line.size():
			var word: String = line.get(j)
			var word_index = line.find(word)
			var clean_word = word.substr(0, word.find("["))
			
			if visible_characters > -1 and display_chars >= visible_characters:
				break
			
			# if current word is first word in processing line
			# and asterisk exists anywhere in the text and it's not in the currently processing line
			# then add the offset
			if word_index == 0 and asterisk and !current_line_asterisk:
				char = 2
				# Unless the first word is also an asterisk
				if word == "*":
					char = 0
			
			# loop over each character in the word
			for i in word.length():
				var ch = word[i]
				total_chars += 1
				
				if ch == "[":
					# check if there's actually a closing bracket left in the text
					if text.find("]", total_chars) > -1:
						command_mode = true
						if word[i+1] == "/":
							text_effects.pop_back()
							is_closing_tag = true
						continue
				if ch == "]":
					command_mode = false
					if is_closing_tag:
						is_closing_tag = false
						continue
					text_effects.append(tag_content)
					tag_content = ""
					continue
				if command_mode:
					if !is_closing_tag:
						tag_content += ch
					continue
				
				var typer_char = Char.new(
					get_theme_default_font(),
					pos + (text_gap * char),
					Vector2(0.0, 0.0),
					ch,
					font_size
				)
				typer_char = apply_effects(typer_char, text_effects)
				
				draw_char(
					typer_char.font,
					typer_char.pos + typer_char.pos_offset,
					typer_char.glyph,
					typer_char.font_size,
					typer_char.color
				)
				clean_word += ch
				
				char += 1
				display_chars += 1
				if visible_characters > -1 and display_chars >= visible_characters:
					break
			
			# if current word is first word in processing line and is an asterisk
			# and there haven't been any asterisks so far then turn on asterisk mode
			# and mark currently processing line as having the asterisk
			if word_index == 0 and word == "*" and !asterisk:
				asterisk = true
				current_line_asterisk = true
			
			# add a space after the word
			if word_index != -1:
				draw_char(
					get_theme_default_font(),
					pos + (text_gap * char),
					" ",
					font_size
				)
				
				total_chars += 1
				if !command_mode:
					char += 1
					display_chars += 1
				else:
					# add a space to tag_content if currently parsing a tag
					# since we're splitting the text and practically erasing all spaces
					tag_content += " "
			
		current_line_asterisk = false
		pos.y += font_size
		char = 0

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

## Dictionary to register every effect
static var typer_effects_registry: Dictionary = {
	"color": ColorTyperEffect.new(),
	"shake": ShakeTyperEffect.new()
}
