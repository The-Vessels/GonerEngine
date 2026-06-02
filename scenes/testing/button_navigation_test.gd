extends HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.grab_focus.call_deferred()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
