class_name ColorTyperEffect extends TyperEffect

func effect_char(char: Typer.Char, params: Dictionary, time: int) -> Typer.Char:
	var color = params.get("color")
	char.color = Color.from_string(color, Colors.c_white)
	return char
