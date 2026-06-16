extends Node

enum Facing {
	RIGHT,
	UP,
	LEFT,
	DOWN
}

var facing_arr = [Facing.RIGHT, Facing.DOWN, Facing.LEFT, Facing.UP]
var facing_str = ["right", "up", "left", "down"]

func calc_facing_from_dir(dir: Vector2) -> Enums.Facing:
	if dir.x == 1.0:
		return Enums.Facing.RIGHT
	if dir.y == 1.0:
		return Enums.Facing.DOWN
	if dir.x == -1.0:
		return Enums.Facing.LEFT
	if dir.y == -1.0:
		return Enums.Facing.UP
	
	assert(false)
	return Enums.Facing.DOWN

# Some kind of weird math here.
# Maybe I should explain it later.
func facing_from_dir(dir: Vector2) -> Facing:
	var angle := dir.angle()
	var divided := angle / (PI / 2)
	var rounded := roundi(divided)
	var positive := fposmod(rounded, 4.0)
	return facing_arr[positive]

# I don't know why I want to "optimize" so bad.
# I just have so much fun writing code like this!
func facing_to_string(facing: Enums.Facing) -> String:
	return facing_str[facing]
