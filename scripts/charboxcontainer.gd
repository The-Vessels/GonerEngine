@tool
extends Container

func activate() -> void:
	get_child(0).activate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		var xpos: Array[int]
		var count := get_child_count()
		if count == 3:
			xpos = [0, 213, 426]
		elif count == 2:
			xpos = [108, 322]
		elif count == 1:
			xpos = [213]
		elif count == 0:
			return
		else:
			push_error("You have more than 3 children! IDK what to do here lol")
			return
		
		for i in range(count):
			get_child(i).position.x = xpos[i]
			get_child(i).position.y = 0.0
