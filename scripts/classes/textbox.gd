@icon("uid://bw0iqumaar5ok")
@tool
class_name TextBox extends Control
## A Control node for a DELTARUNE dialogue box.
## 
## [b]Note:[/b] Not meant to be instantiated directly.
## [br]
## Instead, use [method TextBox.start_dialogue] (or [method TextBox.create] if you only need a [b]TextBox[/b] node).

@export_multiline var text: Array[String] = [""]:
	set(new):
		text = new
		if Engine.is_editor_hint():
			set_text(text[text_index])
			set_asterisks()

@export var faces: Array[String] = [""]

@onready var ast = $HBoxContainer/asterisks
@onready var dia = $HBoxContainer/dialoguetext
@onready var dark_box: NinePatchRect = $DarkBox
@onready var light_box: NinePatchRect = $LightBox

@export_group("Talking Sound")
@export var talk_sounds: Array[AudioStream]
@export_subgroup("Random Pitch Range")
@export_range(-1, 0, 0.1) var lower_range: float = 0.0
@export_range(0, 1, 0.1) var upper_range: float = 0.0

const textbox_scene: PackedScene = preload("uid://c5nrska6i801g")

static var has_textbox := false

var animating := false
var text_index := 0

# this is actually called a `paragraph` in `RichTextLabel`
# because each line here means includes wrapped lines
var line_starts_with_asterisk: Array[bool] = []
var has_asterisks: bool

static func start_dialogue(text: Array, faces: Array) -> void:
	Signals.startDialogue.emit(text, faces)

func line_asterisk(line: String) -> bool:
	return (len(line) == 1 and line[0] == '*') \
		or (line.substr(0,2) == '* ')

# Creates a new textbox.
static func create(text: Array, faces: Array) -> TextBox:
	var textbox_inst: TextBox = textbox_scene.instantiate()
	#textbox_inst.text = text
	# append_array needed otherwise godot is weird
	textbox_inst.text.clear()
	textbox_inst.text.append_array(text)
	textbox_inst.faces.clear()
	textbox_inst.faces.append_array(faces)
	return textbox_inst

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
	has_textbox = true
	
	match Global.world_type:
		Global.WorldTypes.WORLD_LIGHT:
			dark_box.visible = false
			light_box.visible = true
			$TalkSprite.set_position(Vector2(64.0, 350.0))
		Global.WorldTypes.WORLD_DARK:
			dark_box.visible = true
			light_box.visible = false
			$TalkSprite.set_position(Vector2(69.0, 350.0))
	
	set_text(text[text_index])
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
			play_talk_sound()
		await get_tree().physics_frame
	animating = false

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
	

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	#Set box style
	match Global.world_type:
		Global.WorldTypes.WORLD_LIGHT:
			dark_box.visible = false
			light_box.visible = true
			$TalkSprite.set_position(Vector2(64.0, 350.0))
		Global.WorldTypes.WORLD_DARK:
			dark_box.visible = true
			light_box.visible = false
			$TalkSprite.set_position(Vector2(69.0, 350.0))
	
	$TalkSprite.texture = load(faces[text_index])
	ast.visible_characters = dia.get_visible_line_count()
	if Input.is_action_just_pressed("confirm") and !animating:
		text_index += 1
		if text_index >= text.size():
			queue_free()
			has_textbox = false
			return
		
		set_text(text[text_index])
		set_asterisks()
		animate_text()

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
