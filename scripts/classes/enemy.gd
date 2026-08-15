class_name Enemy extends Actor

func _enter_tree() -> void:
	add_to_group("enemy")

func get_hp() -> float:
	return 0.1234

func get_mercy() -> float:
	return 0.5678
