extends HBoxContainer

func activate() -> void:
	$Fight.grab_focus.call_deferred()

func _ready():
	for child: TextureButton in get_children():
		child.focus_exited.connect(func(): Global.play_ui_sound('menumove'))
		child.pressed.connect(func(): Global.play_ui_sound('select'))
