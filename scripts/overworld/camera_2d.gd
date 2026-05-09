extends Camera2D

@onready var Player: player = $"../Player"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position = Player.position
