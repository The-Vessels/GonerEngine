extends CharacterBody2D

var hp = 120
const SPEED = 120
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	var Xmovement = Input.get_axis("left","right") * SPEED
	var Ymovement = Input.get_axis("up","down") * SPEED
	velocity = Vector2(Xmovement,Ymovement)
	position += velocity * delta
	SoulRefrence.soulPosition = position

func _ready() -> void:
	SoulRefrence.soulPosition = position
	
	
func _damage(damage) -> void:
	hp -= damage
	print("oh fuck i took" + str(damage) + 'damage! now my hp is' + str(hp) + "!")
