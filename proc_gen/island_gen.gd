extends Node2D

const MAX_ISLAND_SIZE = 8  # Maximum size of the island in tiles
const MIN_ISLAND_SIZE = 4  # Minimum size of the island in tiles
const TILE_SIZE = 16  # Size of each tile in pixels
const CHUNK_SIZE = 64

@export var tilemap: TileMap
@export var water_tile: Vector2 = Vector2(2, 0)  # Assuming (2,0) is the water tile in the atlas
@export var island_tile: Vector2 = Vector2(1, 0)  # Assuming (1,0) is the island tile in the atlas

func _ready():
	generate_island()

func generate_island():
	var island_size = randf_range(MIN_ISLAND_SIZE, MAX_ISLAND_SIZE)
	var start_x = randi() % (CHUNK_SIZE - island_size)
	var start_y = randi() % (CHUNK_SIZE - island_size)

	for x in range(island_size):
		for y in range(island_size):
			var tile_pos = Vector2i(start_x + x, start_y + y)
			tilemap.set_cell(0, tile_pos, 0, island_tile)
