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

@onready var ast = $HBoxContainer/asterisks
@onready var dia: RichTextLabel = $HBoxContainer/dialoguetext
@onready var dark_box: NinePatchRect = $DarkBox
@onready var light_box: NinePatchRect = $LightBox

@export_group("Talking Sound")
@export var talk_sounds: Array[AudioStream]
@export_subgroup("Random Pitch Range")
@export_range(-1, 0, 0.1) var lower_range: float = 0.0
@export_range(0, 1, 0.1) var upper_range: float = 0.0

const textbox_scene: PackedScene = preload("uid://c5nrska6i801g")

static var has_textbox := false

var animating: bool = false
var pause: int = 0
var text_index: int = 0

# this is actually called a `paragraph` in `RichTextLabel`
# because each line here means includes wrapped lines
var line_starts_with_asterisk: Array[bool] = []
var has_asterisks: bool

static func start_dialogue(text: Array) -> void:
	Signals.startDialogue.emit(text)

func line_asterisk(line: String) -> bool:
	return (len(line) == 1 and line[0] == '*') \
		or (line.substr(0,2) == '* ')

# Creates a new textbox.
static func create(text: Array) -> TextBox:
	var textbox_inst: TextBox = textbox_scene.instantiate()
	#textbox_inst.text = text
	# append_array needed otherwise godot is weird
	textbox_inst.text.clear()
	textbox_inst.text.append_array(text)
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
	
	dia.visible_ratio = 0.0
	#var parsed_text = parse_commands(text[text_index])
	set_text(text[text_index])
	parse_commands()
	set_asterisks()

class CommandInfo:
	var index: int
	var command: String
	func _init(idx: int, cmd: String):
		index = idx
		command = cmd

var commands: Array[CommandInfo] = []
# Gets all the commands inside the dia text and adds them to the list of commands
func parse_commands():
	print(dia.get_parsed_text())
	commands.clear()
	while true:
		# find the index of where the command starts (break the loop if it doesnt find any more)
		var left_index = dia.get_parsed_text().findn("{")
		if left_index == -1: break
		# find the index of where the command ends (break the loop if it doesnt find any more)
		var right_index = dia.get_parsed_text().findn("}", left_index)
		if right_index == -1: break
		
		var tag_content = dia.get_parsed_text().substr(left_index+1, right_index-1-left_index)
		
		# erase the command from the dialogue text
		dia.text = dia.text.erase(dia.text.findn("{"+tag_content+"}"), right_index+1-left_index)
		
		var command = CommandInfo.new(left_index, tag_content)
		commands.append(command)

func evaluate(command, variable_names = [], variable_values = []) -> void:
	var expression = Expression.new()
	var error = expression.parse(command, variable_names)
	if error != OK:
		push_error(expression.get_error_text())
		return

	var result = expression.execute(variable_values, self)

	if not expression.has_execute_failed():
		print(str(result))
	
	commands.remove_at(0)

func wait(frames: int) -> void:
	pause = frames

func write_char():	
	# Check if the index of the char you're about to write has a command queued for it
	if commands:
		if dia.visible_characters == commands[0].index:
			print(commands[0].command)
			evaluate(commands[0].command)
	dia.visible_characters += 1
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
	

func _process(_delta: float) -> void:
	if Engine.is_editor_hint() or !is_node_ready():
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

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("confirm") and !animating:
		text_index += 1
		if text_index >= text.size():
			queue_free()
			has_textbox = false
			return
		
		dia.visible_ratio = 0.0
		#var parsed_text = parse_commands(text[text_index])
		set_text(text[text_index])
		parse_commands()
		set_asterisks()
	
	if animating and Input.is_action_just_pressed("cancel"):
		dia.visible_ratio = 1.0
	
	if !(dia.visible_ratio >= 1.0):
		animating = true
		if pause <= 0:
			write_char()
	else:
		animating = false
	
	if pause > 0: pause -= 1
