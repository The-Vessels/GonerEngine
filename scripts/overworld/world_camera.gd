# Main camera of the entire game
extends Camera2D

@export var target: Node2D

func _ready() -> void:
	# Set the player to be the target of the camera by default
	#if !target:
		#target = player
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_node_ready():
		if target:
			anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
			self.position = target.global_position
		else:
			anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
			self.position = Vector2(0.0, 0.0)
