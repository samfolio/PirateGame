extends Node2D

@onready var tilemap : TileMap = get_tree().current_scene.get_node("TileMap")
@onready var player : CharacterBody2D = get_tree().current_scene.get_node("Player")

const width: int = 128
const height: int = 128
const ISLAND_PROBABILITY: float = 0.1

var _loaded_chunks = []
var _occupied_positions = []

func _ready():
	pass
	
func _process(_delta):
	var player_tile_pos = tilemap.local_to_map(player.position)
	
	generate_chunk(player_tile_pos)
	
	unload_distant_chunk(player_tile_pos)
	
	#_place_scene(player_tile_pos, enemy, .005, %TileMap, "enemy")
	
func generate_chunk(pos):
	for x in range(width):
		for y in range(height):
			
			var water_atlas : Vector2 = Vector2(2,0)

			tilemap.set_cell(0, Vector2i(pos.x - (width/2) + x, pos.y - (height/2) + y), 0, water_atlas)
				
			if Vector2i(pos.x, pos.y) not in _loaded_chunks:
				_loaded_chunks.append(Vector2i(pos.x, pos.y))
				
	# Generate islands
	if randi() % 100 < ISLAND_PROBABILITY * 100:
		generate_island(pos)

func unload_distant_chunk(player_pos):
	var unload_dist = (width * 2 + 1)
	
	for chunk in _loaded_chunks:
		var dist_to_player = dist(chunk, player_pos)
		
		if dist_to_player > unload_dist:
			clear_chunk(chunk)
			_loaded_chunks.erase(chunk)

func clear_chunk(pos):
	for x in range(width):
		for y in range(height):
			tilemap.set_cell(0, Vector2i(pos.x - (width/2) + x, pos.y - (height/2) + y), -1, Vector2(-1,-1))
				
func dist(p1,p2):
	var r = p1-p2
	return sqrt(r.x ** 2 + r.y ** 2)
	
func generate_island(chunk_pos):
	# TODO: why isn't this working?
	# TODO: I should use terrain generation here maybe?
	var island_size = randi() % 5 + 12
	var start_x = chunk_pos.x * height + randi() % (height - island_size)
	var start_y = chunk_pos.y * height + randi() % (height - island_size)

	for x in range(island_size):
		for y in range(island_size):
			var tile_pos = Vector2i(start_x + x, start_y + y)
			var island_atlas = Vector2(5, 1) 
			tilemap.set_cell(1, tile_pos, 1, island_atlas)
			_occupied_positions.append(tile_pos)
	
	print("Generated Island of size ",island_size ," at ", start_x, ":", start_y)
	
func place_scene(chunk_position: Vector2i, scene: PackedScene, density: float, parent: Node, scene_name: String):
	var start_position = chunk_position * Vector2i(width, height)
	
	# place a scene
	for i in range(width * height * density):
		var scene_position = start_position + Vector2i(randf_range(0, width), randf_range(0, height)) * $TileMap.tile_set.tile_size
		if scene_position not in _occupied_positions:
			var scene_instance = scene.instantiate()
			scene_instance.position = scene_position * TileMap.tile_set.tile_size
			parent.add_child(scene_instance)
			_occupied_positions.append(scene_position)
			print("Placing ", scene_name, "@", scene_instance.position)
