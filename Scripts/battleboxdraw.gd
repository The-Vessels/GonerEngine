extends StaticBody2D
<<<<<<< HEAD
var boxsize = Vector2(50,50)
var boxpos = Vector2(-25,-25)
var afterimageTimer = 0
var tween: Tween = null

var x := 0.0

@onready var label: Label = get_node('../Label')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var button: Button = get_node('../Button')
	button.pressed.connect(onpress)
=======
var boxsize = Vector2(200,200)
var boxpos = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boxpos = Vector2(get_viewport().size / 2) - (boxsize / 2)
	
>>>>>>> origin/bullets

func onpress() -> void:
	tween = create_tween()
	tween.tween_property($Sprite2D, 'rotation', 0.0, 1.0).from(-50.0)
	tween.parallel().tween_property($Sprite2D, 'scale:x', 1.0, 1.0).from(0.1)
	tween.parallel().tween_property($Sprite2D, 'scale:y', 1.0, 1.0).from(0.1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
<<<<<<< HEAD
# 'delta' is that a deltarune reference?!?!?!
func _process(delta: float) -> void:
	# is your tween running?
	# then you better go catch it!
	if tween != null and tween.is_running():
		var afterimage: Sprite2D = $Sprite2D.duplicate()
		# afterimage.z_index = 0
		var after_tween = afterimage.create_tween()
		after_tween.tween_property(afterimage, 'modulate:a', 0.0, 1.0)
		after_tween.tween_callback(afterimage.queue_free)
		add_child(afterimage)
		label.text = 'Child count: %d' % get_child_count()
=======

>>>>>>> origin/bullets


func approach(val, target, amount):
	if target < val:
		return
	
