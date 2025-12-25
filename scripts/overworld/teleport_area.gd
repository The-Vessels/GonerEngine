class_name TeleportArea extends Area2D

@export_file("*.tscn") var destination_scene

@onready var scene_container: Node = get_tree().root \
	.get_child(-1).get_node("SceneContainer")

func _ready():
	body_entered.connect(_on_body_entered)
	print('HIIIIII ', scene_container)

func _on_body_entered(_body: Node2D) -> void:
	var child := scene_container.get_child(0)
	if child != null:
		child.queue_free()
	if scene_container.get_child_count() == 1:
		var scene: PackedScene = load(destination_scene)
		var instantiated := scene.instantiate()
		scene_container.add_child.call_deferred(instantiated)
