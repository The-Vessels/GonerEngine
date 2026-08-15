extends Control

func _ready() -> void:
	for child in $VBoxContainer.get_children():
		child.queue_free()
	
	
	
	var enemy_entries := $VBoxContainer.get_children()
	enemy_entries[0].focus_neighbor_top = enemy_entries[-1].get_path()
	enemy_entries[-1].focus_neighbor_bottom = enemy_entries[0].get_path()
	enemy_entries[0].grab_focus.call_deferred()
	#$VBoxContainer/SoulButton.grab_focus.call_deferred()
