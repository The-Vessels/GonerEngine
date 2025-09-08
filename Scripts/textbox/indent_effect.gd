class_name IndentEffect extends RichTextEffect

var bbcode = 'kevin'
var thing = ''
# ts pmo icl
var ts = TextServerManager.get_primary_interface()

func _init():
	print('BROOO 222')

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	char_fx.color = Color8(255, 255, 0, 255)
	# var mychar = ts.font_get_char_from_glyph_index(char_fx.font, 100, char_fx.glyph_index)
	print(char_fx.relative_index, char_fx.range)
	# print(char(mychar) == ' ', char_fx.glyph_flags & TextServer.GRAPHEME_IS_BREAK_HARD)
	return true
