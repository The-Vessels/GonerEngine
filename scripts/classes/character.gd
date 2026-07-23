class_name Character extends Resource
## A Resource for storing the info for a character.
##
## In Deltarune, examples of Characters include
## Kris, Susie, Ralsei, Noelle, Queen, Flowery, Tasque, Nubert, etc.

@export var name: String
@export var caterpillar_offset: Vector2

@export var states: Dictionary[String, SpriteFrames]
# @export var animation: SpriteFrames

# `state` is blank for default state.
func get_animation(state: String) -> SpriteFrames:
	var suffix := "" if state == "" else "_" + state
	var worldtype_str := "dark" if Global.is_dark() else "light"
	if states.has(worldtype_str + suffix):
		return states.get(worldtype_str + suffix)
	elif states.has(state):
		return states.get(state)
	else:
		return states.get(states.keys()[0])
