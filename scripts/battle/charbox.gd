extends Control

@onready var color_rect_2: ColorRect = $Ctrl/ColorRect2
var party_member: PartyMember
var charcolor: Color

func activate() -> void:
	$Ctrl.is_selected = true
	$BattleButtons.activate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if party_member != null:
		$Ctrl/MainRect/Head.texture = party_member.chara.face_image
		$Ctrl/MainRect/Name.texture = party_member.chara.name_image
		$Ctrl/MainRect/MaxHpLabel.text = str(party_member.chara.default_stats.max_hp)
		charcolor = party_member.chara.color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
