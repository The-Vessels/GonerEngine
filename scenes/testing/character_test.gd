extends Area2D

class TestCutscene extends Cutscene:
	func _run() -> void:
		print('ready!')
		set_party_movement(false)
		
		var susie := get_actor("Susie")
		
		await wait(30)
		
		for i in range(5):
			var pos := Vector2(
				randf_range(100.0, 400.0),
				randf_range(100.0, 400.0)
			)
			await susie.walk_to_point(pos, 30)
			await wait(15)
		
		set_party_movement(true)

func interact() -> void:
	Cutscene.run(TestCutscene.new())
