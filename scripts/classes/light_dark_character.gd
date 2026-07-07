class_name LightDarkCharacter extends Character
## A Character with both Light World and Dark World sprites.

@export var dark_animations: SpriteFrames
@export var light_animations: SpriteFrames

func get_animation() -> SpriteFrames:
	if Global.is_dark():
		return dark_animations
	else:
		return light_animations
