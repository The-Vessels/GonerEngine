class_name TeleportArea extends Area2D

@export_file("*.tscn") var target_scene
@export var target_marker_id: int
@export var player_facing: String

@onready var scene_container: Node = get_tree().root.get_child(-1).get_node("RoomManager")

func _ready():
	body_entered.connect(_on_body_entered)
	print('HIIIIII ', scene_container)

func _on_body_entered(_body: Node2D) -> void:
	Global.changeRoom.emit(target_scene, target_marker_id, player_facing)
