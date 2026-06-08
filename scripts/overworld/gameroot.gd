# This is the root node of the main game.
# For now it just handles quitting
# and switching the menu based on the global world type.

extends Node2D

@onready var quitting_sprite: AnimatedSprite2D = $QuittingLayer/Quitting
@onready var menu_layer: CanvasLayer = $MenuLayer

var quitting_sprite_index := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match Global.world_type:
		Global.WorldTypes.WORLD_LIGHT:
			var menu_scene: PackedScene = load("res://scenes/ui/light_menu.tscn")
			menu_layer.add_child(menu_scene.instantiate())
		Global.WorldTypes.WORLD_DARK:
			var menu_scene: PackedScene = load("res://scenes/ui/dark_menu.tscn")
			menu_layer.add_child(menu_scene.instantiate())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	scale = Vector2(2.0, 2.0) if (Global.is_fullscreen and Global.border_enabled) else Vector2(1.0, 1.0)

func _physics_process(_delta: float) -> void:
	handle_quitting()

func handle_quitting():
	if Input.is_action_pressed("quit"):
		if quitting_sprite_index >= 5.0:
			get_tree().quit()
		
		quitting_sprite.modulate.a += 0.05
		quitting_sprite_index += 0.1
	elif quitting_sprite.modulate.a > 0:
			quitting_sprite_index -= 0.5
			quitting_sprite_index = max(0, quitting_sprite_index)
			
			quitting_sprite.modulate.a -= 0.1
	else:
		quitting_sprite_index = 0.0
			
	quitting_sprite.modulate.a = clampf(quitting_sprite.modulate.a, 0.0, 1.0)
	#print("hi: " + str(quitting_sprite_index) + " becomes " + str(quitting_sprite.frame))
	quitting_sprite.frame = int(quitting_sprite_index)
