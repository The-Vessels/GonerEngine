@tool
extends RichTextLabel

@onready var image_only_label: RichTextLabel = %ImageOnlyLabel

var old_text := text

func _notification(_what: int) -> void:
	if old_text != text:
		old_text = text
		var text_no_color_tags := remove_color_tags(text)
		image_only_label.text = text_no_color_tags

func _ready() -> void:
	print(text)
	# get_character_line()

# TODO support escaping here
func remove_color_tags(string: String) -> String:
	string = string.replace("[/color]", "")
	
	var pos := 0
	while true:
		var left_idx := string.find("[color", pos)
		if left_idx == -1: break
		var right_idx := string.find("]", left_idx + "[color".length())
		if right_idx == -1: break
		
		string = string.substr(0, left_idx) + string.substr(right_idx + 1)
		pos = left_idx
	
	return string

# This doesn't work rn (I'm not using it anyways)
func make_images_black(str: String) -> String:
	var pos := 0
	while true:
		var left_idx = str.find("[img", pos)
		if left_idx == -1: break
		var right_idx = str.find("]", pos)
		if right_idx == -1: break
		pos = right_idx + 1
		
		var tag = str.substr(left_idx, right_idx - left_idx + 1)
		var tag_content = tag.substr(0, tag.length() - 1).substr(4)
		# var tag_words = 
	return str
