extends StaticBody2D

var boxsize = Vector2(50,50)
var boxpos = Vector2(-25,-25)
var afterimageTimer = 0
var tween: Tween = null

var x := 0.0

@onready var label: Label = get_node('../Label')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#var button: Button = get_node('../Button')
	#button.pressed.connect(onpress)

func _on_open_button_pressed() -> void:
	tween = create_tween()
	tween.tween_property($Growtangle, 'rotation', 0.0, 0.5).from(PI)
	tween.parallel().tween_property($Growtangle, 'scale:x', 1.0, 0.5).from(0.0)
	tween.parallel().tween_property($Growtangle, 'scale:y', 1.0, 0.5).from(0.0)

func _on_close_button_pressed() -> void:
	tween = create_tween()
	tween.tween_property($Growtangle, 'rotation', PI, 0.5).from(0.0)
	tween.parallel().tween_property($Growtangle, 'scale:x', 0.0, 0.5).from(1.0)
	tween.parallel().tween_property($Growtangle, 'scale:y', 0.0, 0.5).from(1.0)

func open() -> void:
	pass
	#tween = create_tween()
	#tween.tween_property($Growtangle, 'rotation', 0.0, 0.5).from(PI)
	#tween.parallel().tween_property($Growtangle, 'scale:x', 1.0, 0.5).from(0.0)
	#tween.parallel().tween_property($Growtangle, 'scale:y', 1.0, 0.5).from(0.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.

# 'delta' is that a deltarune reference?!?!?!
func _physics_process(_delta: float) -> void:
	# is your tween running?
	# then you better go catch it!
	if tween != null and tween.is_running():
		var alpha: float = 0.6 - (0.5 * tween.get_total_elapsed_time() * 2)
		
		var box_dup := $Growtangle.duplicate()
		box_dup.is_afterimage = true
		var afterimage: Afterimage = Afterimage.new(0.04 * 30.0, 1.0)
		afterimage.add_child(box_dup)
		afterimage.z_index = self.z_index + 1

		add_child(afterimage)

func _on_button_pressed() -> void:
	tween = create_tween()
	tween.tween_property($Growtangle, 'rotation', 0.0, 0.5).from(PI)
	tween.parallel().tween_property($Growtangle, 'scale:x', 1.0, 0.5).from(0.0)
	tween.parallel().tween_property($Growtangle, 'scale:y', 1.0, 0.5).from(0.0)


func _on_button_2_pressed() -> void:
	tween = create_tween()
	tween.tween_property($Growtangle, 'rotation', PI, 0.5).from(0.0)
	tween.parallel().tween_property($Growtangle, 'scale:x', 0.0, 0.5).from(1.0)
	tween.parallel().tween_property($Growtangle, 'scale:y', 0.0, 0.5).from(1.0)
