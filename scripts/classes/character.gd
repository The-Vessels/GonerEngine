class_name Character extends Resource
## A Resource for storing the info for a character.
##
## In Deltarune, examples of Characters include Kris, Susie, Ralsei, and Noelle.

@export var name: String
@export var caterpillar_offset: Vector2
@export var animation: SpriteFrames

func get_animation() -> SpriteFrames:
	return animation
