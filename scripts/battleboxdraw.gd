extends StaticBody2D

var boxsize = Vector2(50,50)
var boxpos = Vector2(-25,-25)
var afterimageTimer = 0
var tween: Tween = null

var x := 0.0

@onready var label: Label = get_node('../Label')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var button: Button = get_node('Button')
	button.pressed.connect(onpress)


func onpress() -> void:
	tween = create_tween()
	tween.tween_property($Sprite2D, 'rotation', 0.0, 0.5).from(PI)
	tween.parallel().tween_property($Sprite2D, 'scale:x', 1.0, 0.5).from(0.0)
	tween.parallel().tween_property($Sprite2D, 'scale:y', 1.0, 0.5).from(0.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.

# 'delta' is that a deltarune reference?!?!?!
func _physics_process(_delta: float) -> void:
	# is your tween running?
	# then you better go catch it!
	if tween != null and tween.is_running():
		var afterimage: Sprite2D = $Sprite2D.duplicate()
		var alpha = 0.6 - (0.5 * tween.get_total_elapsed_time() * 2)
		afterimage.modulate.a = alpha
		#var after_tween = afterimage.create_tween()
		#after_tween.tween_property(afterimage, 'modulate:a', 0.0, 0.5).from(0.6 - (0.5 * tween.get_total_elapsed_time() * 2))
		#after_tween.tween_callback(afterimage.queue_free)
		add_child(afterimage)
