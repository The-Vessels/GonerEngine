extends Area2D
class_name Bullet
@export var velocity := Vector2()
@export var forwardsVelocity := Vector2()
var soulPosition = Vector2(0,0)
var damage = 17

# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += forwardsVelocity * delta
	position += transform.x + (velocity * delta)
	soulPosition = SoulRefrence.soulPosition

func _on_area_entered(area: Area2D) -> void:
	area._damage(damage)
