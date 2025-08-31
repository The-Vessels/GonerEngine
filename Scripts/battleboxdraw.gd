extends StaticBody2D
var boxsize = Vector2(200,200)
var boxpos = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boxpos = Vector2(get_viewport().size / 2) - (boxsize / 2)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _draw() -> void:
	draw_rect(Rect2(boxpos,boxsize),Color.GREEN,false,4.0)
	draw_rect(Rect2(boxpos,boxsize),Color.BLACK,true,4.0)

func approach(val, target, amount):
	if target < val:
		return
	
