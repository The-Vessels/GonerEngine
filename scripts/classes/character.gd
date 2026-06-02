class_name Character extends CharacterBody2D
## A party member. May be a playable character.

var playable: bool

# FOR PLAYABLE CHARACTER
var running: bool
var runtimer: float = 0.0 # Frames since we started running

func _process(delta: float) -> void:
	var dtmult := delta * 30.0
	
	# Cancel is same button as sprint
	if Input.is_action_pressed("cancel"):
		running = true
		runtimer += dtmult
	else:
		running = false
		runtimer = 0.0

# Retrieves the walk speed (pixels per 30fps frame).
func get_walk_speed() -> int:
	var darkworld: bool = Global.world_type == Global.WorldTypes.WORLD_DARK
	
	var bwspeed := 4 if darkworld else 3
	
	if running:
		var add: int
		if runtimer > 60:
			add = 4
		elif runtimer > 10:
			add = 2
		else:
			add = 1
		
		var mul := 1.8 if darkworld else 1.0
		return bwspeed + round(add * mul)
		
	else:
		return bwspeed
