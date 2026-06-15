class_name Actor extends CharacterBody2D
## Anyone who can be controlled
## by a cutscene.

@export var chara: Character

# An actor dict to store all the actors.
static var actor_dict: Dictionary[String, Actor] = {}

func _enter_tree() -> void:
	actor_dict[chara.name] = self

func _exit_tree() -> void:
	actor_dict[chara.name] = null

static func get_by_name(actor_name: String) -> Actor:
	return actor_dict.get(actor_name)

static func exists(actor_name: String) -> bool:
	return actor_dict.has(actor_name)
