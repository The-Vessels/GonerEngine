extends Control

@export_multiline var test_string: String

@onready var asterisktext = $Box/HBoxContainer/gasterisk
@onready var dialoguetext = $Box/HBoxContainer/dialoguetext
@onready var font: Font = dialoguetext.get_theme_font("normal_font")

func do_thing(text: String):
	var width = dialoguetext.custom_minimum_size.x
	font.get_multiline_string_size(
		text, HORIZONTAL_ALIGNMENT_LEFT, width,
		32, -1, TextServer.BREAK_WORD_BOUND | TextServer.BREAK_ADAPTIVE
	)

func calculate_asterisks(text: String):
	var lines = text.split('\n')
	if len(lines) > 3:
		return ''
	var has_asterisk: Array[bool] = []
	
	var newdialogue = []
	for line in lines:
		var ha = line.substr(0, 2) == '* '
		has_asterisk.append(ha)
		newdialogue.append(line.substr(2) if ha else line)
	
	var asterisk = ''
	for ha in has_asterisk:
		asterisk += ('*' if ha else ' ')
	return [asterisk, '\n'.join(newdialogue)]

func _ready():
	var ret = calculate_asterisks(test_string)
	asterisktext.text = ret[0]
	# dialoguetext.text = ret[1]
