class_name CircularQueue

var positions: Array
var max_length: int
var idx: int = 0
var reset: bool = true

func _init(max_length: int) -> void:
	self.max_length = max_length
	positions = []
	positions.resize(max_length)

func add(value: Variant) -> void:
	if reset:
		reset = false
		positions.fill(value)
	else:
		positions[idx] = value
	idx += 1
	if idx >= max_length:
		idx = 0

# get(0) returns the most recently added position
# get(1) returns the 2nd most recently added position
# get(49) returns the 50th most recently added position
# Try not to get() an index larger than max_length
func get_val(index: int) -> Variant:
	return positions[posmod(-index + idx, max_length)]
