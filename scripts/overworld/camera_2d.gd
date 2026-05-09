extends Camera2D

@onready var tile_map_layer: TileMapLayer = $"../../TileMapLayer"
@onready var player: player = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var tilemap_size = tile_map_layer.get_used_rect()
	#var tilemap_tile_size = tile_map_layer.tile_set.tile_size
	#
	## Calculate pixel boundaries
	#var world_coords = tilemap_size.position * tilemap_tile_size * 2
	#var end_coords = tilemap_size.end * tilemap_tile_size * 2
	#
	#print(world_coords)
	#print(end_coords)
	#
	#limit_left = int(world_coords.x)
	#limit_top = int(world_coords.y)
	#limit_right = int(end_coords.x)
	#limit_bottom = int(end_coords.y)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position = player.position
