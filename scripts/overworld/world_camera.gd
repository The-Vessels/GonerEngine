# Main camera of the entire game
extends Camera2D

@onready var player: Player = $"../RoomManager/Player"

@export var target: Node

func _ready() -> void:
	# Set the player to be the target of the camera by default
	if !target:
		target = player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_node_ready():
		self.position = target.position
