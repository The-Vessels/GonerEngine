extends SubViewportContainer
@onready var border_rect: TextureRect = $SubViewport/BorderTexture
@onready var border_prev_rect: TextureRect = $SubViewport/BorderPrevTexture
var border_trans := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.changeBorder.connect(
		func(border):
			set_border(border)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	visible = true if Global.border_enabled else false
	
	if Global.border_enabled and border_rect.modulate.a < 1.0:
		border_rect.modulate.a += 0.05
	if !Global.border_enabled and border_rect.modulate.a > 0.0:
		border_rect.modulate.a = 0.0
	
	border_rect.modulate.a = clampf(border_rect.modulate.a, 0.0, 1.0)
	
	match Global.border_mode:
		Global.BorderModes.NONE:
			border_rect.visible = false
		Global.BorderModes.SIMPLE:
			border_rect.texture = preload("res://assets/sprites/ui/borders/border_simple.png")
		Global.BorderModes.DYNAMIC:
			border_rect.texture = Global.border_texture

func set_border(new_border):
	border_prev_rect.texture = new_border
	var tween = get_tree().create_tween()
	tween.tween_property(border_prev_rect, "modulate",  Color.WHITE, 1.0)
	tween.tween_property(border_rect, "modulate",  Color.TRANSPARENT, 1.0)
	tween.tween_callback(
		func():
			Global.border_texture = new_border
			border_rect.texture = new_border
			border_rect.modulate.a = 1.0
			border_prev_rect.modulate.a = 0.0
			border_prev_rect.texture = null
	)
