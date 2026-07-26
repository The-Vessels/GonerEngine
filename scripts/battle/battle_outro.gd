class_name BattleOutro extends Cutscene

var bc: BattleController

func _init(battle_controller: BattleController) -> void:
	bc = battle_controller

func _run() -> void:
	var tween := Global.create_tween()
	tween.set_parallel(true)
	
	for i in range(PartyMember.party_list.size()):
		var member := PartyMember.party_list[i]
		member.facing = bc.old_party_facings[i]
		member.play_animation("face_" + Enums.facing_to_string(member.facing))
		tween.tween_property(member, "global_position", bc.old_party_positions[i], 10/30.0)
	
	await tween.finished
