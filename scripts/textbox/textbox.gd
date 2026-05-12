@tool
class_name TextBox extends Control

@export_multiline var text: String = '':
	set(new):
		text = new
		if Engine.is_editor_hint():
			set_text(text)
			set_asterisks()

@onready var ast = $HBoxContainer/asterisks
@onready var dia = $HBoxContainer/dialoguetext
@onready var dark_box: NinePatchRect = $DarkBox
@onready var light_box: NinePatchRect = $LightBox

var animating := false

# this is actually called a `paragraph` in `RichTextLabel`
# because each line here means includes wrapped lines
var line_starts_with_asterisk: Array[bool] = []
var has_asterisks: bool

func line_asterisk(line: String) -> bool:
	return (len(line) == 1 and line[0] == '*') \
		or (line.substr(0,2) == '* ')

func set_text(text: String):
	line_starts_with_asterisk.clear()
	var lines = text.split('\n')
	var new_lines: Array[String] = []
	for line in lines:
		var lswa = line_asterisk(line)
		line_starts_with_asterisk.append(lswa)
		new_lines.append(line.substr(2) if lswa else line)
	dia.text = '\n'.join(new_lines)

func set_asterisks():
	var lineno = 0
	ast.visible = false
	ast.text = ''
	for i in range(dia.get_paragraph_count()):
		while dia.get_line_offset(lineno) < dia.get_paragraph_offset(i):
			lineno += 1
			ast.text += ''
		if line_starts_with_asterisk[i]:
			ast.text += '*'
			ast.visible = true
		else:
			ast.text += ' '
		lineno += 1
	ast.visible_characters = 0

func _ready():
	match Global.world_type:
		Global.WorldTypes.WORLD_LIGHT:
			dark_box.visible = false
			light_box.visible = true
			$TalkSprite.set_position(Vector2(64.0, 350.0))
		Global.WorldTypes.WORLD_DARK:
			dark_box.visible = true
			light_box.visible = false
			$TalkSprite.set_position(Vector2(69.0, 350.0))
	
	set_text(text)
	set_asterisks()
	animate_text()


func animate_text():
	var text: String = dia.get_parsed_text()
	print(text)
	dia.visible_characters = 0
	while dia.visible_characters < dia.get_total_character_count():
		if Input.is_action_just_pressed("cancel"):
			dia.visible_characters = dia.get_total_character_count()
			animating = false
			return
		animating = true
		dia.visible_characters += 1
		if text[dia.visible_characters - 1] != ' ':
			$talkblip.play()
		await get_tree().physics_frame
	animating = false

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	match Global.world_type:
		Global.WorldTypes.WORLD_LIGHT:
			dark_box.visible = false
			light_box.visible = true
			$TalkSprite.set_position(Vector2(64.0, 350.0))
		Global.WorldTypes.WORLD_DARK:
			dark_box.visible = true
			light_box.visible = false
			$TalkSprite.set_position(Vector2(69.0, 350.0))
	ast.visible_characters = dia.get_visible_line_count()

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
