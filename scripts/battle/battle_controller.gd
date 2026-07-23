class_name BattleController extends Node2D
## Manages everything in a battle.

const battle_controller_scene: PackedScene = preload("uid://bsn3lnx86eo3e")

var old_moveable: bool
var old_party_z: int

# For now, BattleController will be added as a child of Room
# because it is the most convenient.
# TODO should we add BattleController to a room like this?
static func spawn() -> BattleController:
	var bc: BattleController = battle_controller_scene.instantiate()
	var room: Room = Global.get_tree().get_first_node_in_group("room")
	room.add_child(bc)
	return bc

static func get_hero_pos(idx: int, n_members: int) -> Vector2:
	const hero_x := 80.0
	var hero_y: float
	
	if n_members == 3:
		hero_y = [50.0, 130.0, 210.0][idx]
	elif n_members == 2:
		hero_y = [100, 180][idx]
	elif n_members == 1:
		hero_y = 140
	else:
		push_error("Could not find battle Y position for %d party members", n_members)
		hero_y = 140
	
	return WorldCamera.get_pos() + Vector2(hero_x, hero_y)

func _ready() -> void:
	print('READYING!!!')
	if Global.in_battle:
		queue_free()
		return
	Global.in_battle = true
	old_moveable = Global.moveable
	Global.moveable = false
	
	global_scale = Vector2.ONE
	global_position = WorldCamera.get_pos()
	
	var party_list := get_party_list_node()
	old_party_z = party_list.z_index
	party_list.z_index = 1000
	party_list.z_as_relative = false
	battle_intro()

func get_party_list_node() -> Node2D:
	return PartyMember.party_list[0].get_parent()

func end_battle() -> void:
	Global.moveable = old_moveable
	Global.in_battle = false
	var party_list := get_party_list_node()
	party_list.z_as_relative = true
	party_list.z_index = old_party_z
	queue_free()

# TODO should this be a cutscene or not?
# TODO wait, do we even need cutscene to be a class?
# Okay, this is getting a bit weird
func battle_intro() -> void:
	await Cutscene.run(BattleIntro.new(self))
	end_battle()

func _process(_delta: float) -> void:
	global_position = WorldCamera.get_pos()
