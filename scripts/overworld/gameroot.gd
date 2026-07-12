# This is the root node of the main game.
# It handles: game scaling and switching the menu based on starting world type

extends Node2D

@onready var menu_layer: CanvasLayer = $MenuLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var menu_scene: PackedScene
	if Global.is_dark():
		menu_scene = load("res://scenes/ui/dark_menu.tscn")
	else:
		menu_scene = load("res://scenes/ui/light_menu.tscn")
	
	var menu_node: Control = menu_scene.instantiate()
	menu_node.visible = false
	menu_layer.add_child(menu_node)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	scale = Vector2(2.0, 2.0) if (Settings.is_fullscreen and Settings.border_enabled) else Vector2(1.0, 1.0)
