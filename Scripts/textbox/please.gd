@tool
extends Control

@export_multiline var text: String = '':
	set(new):
		text = new
		set_text(text)
		set_asterisks()

@onready var ast = $Box/HBoxContainer/asterisks
@onready var dia = $Box/HBoxContainer/dialoguetext

# this is actually called a `paragraph` in `RichTextLabel`
# because each line here means includes wrapped lines
var line_starts_with_asterisk: Array[bool] = []

func set_text(text: String):
	line_starts_with_asterisk.clear()
	var lines = text.split('\n')
	var new_lines: Array[String] = []
	for line in lines:
		var lswa = (line.substr(0, 2) == '* ')
		line_starts_with_asterisk.append(lswa)
		new_lines.append(line.substr(2) if lswa else line)
	dia.text = '\n'.join(new_lines)

func set_asterisks():
	var lineno = 0
	ast.text = ''
	for i in range(dia.get_paragraph_count()):
		while dia.get_line_offset(lineno) < dia.get_paragraph_offset(i):
			lineno += 1
			ast.text += ' '
		ast.text += '*' if line_starts_with_asterisk[i] else ' '
		lineno += 1

func _ready():
	pass

#func paragraph_starts_with_asterisk(i: int):
	#var offset = get_paragraph_offset(i)
	#for j in range(get_line_count()):
		#if get_line_offset(j) == offset:
			#pass
#
#func _ready():
	#print('Lines: %d' % get_paragraph_count())
	#for i in range(get_paragraph_count()):
		#print(get_paragraph_offset(i))
