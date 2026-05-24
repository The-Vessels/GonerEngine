extends Control

@onready var options_container: VBoxContainer = $Main/Options/OptionsContainer
@onready var submenus: Control = $Submenus
@onready var items_list: VBoxContainer = $Submenus/ITEM/ItemList
@onready var item_actions: Panel = $Submenus/ITEM/ItemActions

var menu_options: Array[Node]
var submenu_list: Array[Node]

var current_option := 0
var current_submenu: Node
var current_submenu_buttons: Array[Button]

var submenu_open := false

# Item menu specific stuff
var item_list_buttons: Array[Button]
var item_action_buttons: Array[Button]
var in_item_actions := false
var current_item_action := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menu_options = options_container.get_children()
	submenu_list = submenus.get_children()
	
	# Setup option buttons
	for option_button: Button in menu_options:
		option_button.pressed.connect(
			func():
				current_submenu = submenu_list[option_button.get_index()]
				handle_submenu(current_submenu)
				submenu_open = true
		)
		option_button.focus_entered.connect(
			func():
				if current_option != option_button.get_index():
					Global.play_ui_sound("menumove")
				current_option = option_button.get_index()
		)
	
	# Setup submenu buttons
	for submenu in submenu_list:
		if submenu.name == "CELL":
			var submenu_buttons := get_submenu_buttons(submenu)
			
			for submenu_button: Button in submenu_buttons:
				submenu_button.focus_entered.connect(
					func():
						if submenu_open:
							Global.play_ui_sound("menumove")
						current_option = submenu_buttons.find(submenu_button)
				)
		if submenu.name == "ITEM":
			item_list_buttons = get_submenu_buttons(items_list)
			item_action_buttons = get_submenu_buttons(item_actions)
			
			for item_list_button: Button in item_list_buttons:
				item_list_button.focus_entered.connect(
					func():
						current_option = item_list_buttons.find(item_list_button)
						if (submenu_open and !in_item_actions) or current_option != current_item_action:
							Global.play_ui_sound("menumove")
				)
				item_list_button.pressed.connect(
					func():
						items_list.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_DISABLED
						item_actions.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_ENABLED
						item_action_buttons[current_item_action].grab_focus()
						in_item_actions = true
				)
			for item_action_button: Button in item_action_buttons:
				item_action_button.focus_entered.connect(
					func():
						if submenu_open and in_item_actions:
							Global.play_ui_sound("menumove")
						current_item_action = item_action_buttons.find(item_action_button)
				)

func _process(delta: float) -> void:
	if !is_node_ready():
		return
	
	if submenu_open:
		options_container.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_DISABLED
	
	if Input.is_action_just_pressed("cancel"):
		if submenu_open:
			if in_item_actions:
				items_list.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_ENABLED
				item_actions.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_DISABLED
				
				item_list_buttons[current_option].grab_focus()
				current_item_action = 0
				in_item_actions = false
			else:
				options_container.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_ENABLED
				
				menu_options[current_submenu.get_index()].grab_focus.call_deferred()
				current_submenu.visible = false
				submenu_open = false
		else:
			visible = false
	
	if Input.is_action_just_pressed("menu"):
		if visible:
			if !submenu_open:
				visible = false
		else:
			visible = true

func _on_visibility_changed() -> void:
	if visible and is_node_ready():
		menu_options[current_option].grab_focus.call_deferred()
		Global.play_ui_sound("menumove")

func get_submenu_buttons(submenu) -> Array[Button]:
	var submenu_buttons: Array[Button]
	for child in submenu.get_children():
		if child is Button:
			submenu_buttons.append(child)
	return submenu_buttons

func handle_submenu(submenu) -> void:
	submenu.visible = true
	current_submenu_buttons = item_list_buttons if submenu.name == "ITEM" else get_submenu_buttons(submenu)
	
	if current_submenu_buttons:
		current_submenu_buttons[0].grab_focus()
	else:
		current_option = 0
