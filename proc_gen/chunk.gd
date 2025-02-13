extends Node2D

const CHUNK_SIZE = 64  # Number of tiles per chunk
const TILE_SIZE = 16  # Size of each tile in pixels
const ISLAND_PROBABILITY = 0.1  # Probability of an island appearing in the chunk

@export var tilemap: TileMap
@export var water_tile: Vector2 = Vector2(2, 0)  # Assuming (2,0) is the water tile in the atlas
@export var island_scene: PackedScene

func _ready():
	generate_chunk()

func generate_chunk():
	for x in range(CHUNK_SIZE):
		for y in range(CHUNK_SIZE):
			var tile_pos = Vector2i(x, y)
			tilemap.set_cell(0, tile_pos, 0, water_tile)

	# Generate islands
	if randi() % 100 < ISLAND_PROBABILITY * 100:
		var island_instance = island_scene.instance()
		island_instance.position = Vector2(randi() % (CHUNK_SIZE * TILE_SIZE), randi() % (CHUNK_SIZE * TILE_SIZE))
		add_child(island_instance)
