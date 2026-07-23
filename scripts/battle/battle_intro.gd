class_name BattleIntro extends Cutscene

var bc: BattleController
func _init(the_bc: BattleController) -> void:
	self.bc = the_bc

func _run() -> void:
	for i in range(PartyMember.party_list.size()):
		var member := PartyMember.party_list[i]
		if member != null and member is PartyMember:
			run_party_member(member, i)
	await wait(10)
	Global.play_sound("battle/impact", 0.7)
	Global.play_sound("battle/weaponpull_fast", 0.8)
	for member in PartyMember.party_list:
		member.play_animation("battle_intro_land")
	await wait(14)
	for member in PartyMember.party_list:
		member.play_animation("battle_idle")
	await wait(30)

func run_party_member(member: PartyMember, idx: int) -> void:
	member.play_animation("battle_intro")
	var tween := member.create_tween()
	var dest_pos := BattleController.get_hero_pos(
		idx, len(PartyMember.party_list)
	)
	tween.tween_property(member, "global_position", dest_pos, 10/30.0)
	
	await Global.get_tree().physics_frame
	while tween.is_running():
		var afterimage := Afterimage.new(0.04*30.0, 0.5)
		afterimage.texture = member.get_current_texture()
		bc.add_child(afterimage)
		afterimage.centered = false
		afterimage.global_position = member.global_position
		afterimage.global_scale = member.global_scale
		afterimage.offset = member.get_sprite_offset()
		print(afterimage.global_position, ' and ', member.global_position)
		await Global.get_tree().physics_frame
