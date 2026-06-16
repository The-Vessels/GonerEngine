extends Node2D

class MyCutscene extends Cutscene:
	func _run() -> void:
		print('ready!')
		
		var susie := get_actor("susie")
		
		await wait(30)
		
		for i in range(5):
			var pos := Vector2(
				randf_range(100.0, 400.0),
				randf_range(100.0, 400.0)
			)
			await susie.walk_to_point(pos, 30)
			await wait(15)

func _ready():
	Cutscene.run(MyCutscene.new())
