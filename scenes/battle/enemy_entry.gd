extends SoulButton

var enemy: Enemy = null

func _ready() -> void:
	if enemy != null:
		text = enemy.chara.name
		$HPBar.value = enemy.get_hp()
		$MercyBar.value = enemy.get_mercy()
