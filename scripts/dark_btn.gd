extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	focus_entered.connect(
		func():
			if Global.darkMenuOpened:
				Global.play_ui_sound('menumove')
				Global.selectedDarkBtn = self.get_index()
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _pressed() -> void:
	Global.play_ui_sound('select')
