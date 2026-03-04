extends Control

@export var isCurrentHero := false
@onready var color_rect_2: ColorRect = $Ctrl/ColorRect2

func activate() -> void:
	$Ctrl.is_selected = true
	$BattleButtons.activate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isCurrentHero:
		# TODO: Character Colors
		color_rect_2.color = Global.c_aqua
	else:
		color_rect_2.color = Color(0.129, 0.078, 0.129, 1.0)
