# Main camera of the entire game
class_name WorldCamera extends Camera2D
## The main camera.
## Get the position of the top-left corner with [method get_position].
## Get the size of the camera with [method get_size].

static var instance: WorldCamera

@export var target: Node2D

func _enter_tree() -> void:
	instance = self
func _exit_tree() -> void:
	if instance == self:
		instance = null

func _ready() -> void:
	# Set the player to be the target of the camera by default
	#if !target:
		#target = player
	pass

## Gets the size of the camera.
static func get_size() -> Vector2:
	return instance.get_rect().size

## Gets the position of the top-left corner of the camera.
static func get_pos() -> Vector2:
	return instance.get_rect().position

func get_rect() -> Rect2:
	var size := get_viewport_rect().size
	var pos := get_screen_center_position() - (size / 2.0)
	return Rect2(pos, size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_node_ready():
		if target:
			anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
			self.position = target.global_position
		else:
			anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
			self.position = Vector2(0.0, 0.0)
