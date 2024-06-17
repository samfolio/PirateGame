extends TileMap

var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()

var width = 64
var height = 64

@onready var player = get_tree().current_scene.get_node("Player")


var _loaded_chunks = []
var _occupied_positions = []

func _ready():
	moisture.seed = randi()
	temperature.seed = randi()
	altitude.seed = randi()
	
	altitude.frequency = 0.01
	
func _process(_delta):
	var player_tile_pos = local_to_map(player.position)
	
	generate_chunk(player_tile_pos)
	
	unload_distant_chunk(player_tile_pos)
	
	#_place_scene(player_tile_pos, enemy, .005, %TileMap, "enemy")
	
func generate_chunk(pos):
	for x in range(width):
		for y in range(height):
			
			var moist = moisture.get_noise_2d(pos.x - (width/2) + x, pos.y - (height/2) + y) * 10
			var temp = temperature.get_noise_2d(pos.x - (width/2) + x, pos.y - (height/2) + y) * 10
			var alt = altitude.get_noise_2d(pos.x - (width/2) + x, pos.y - (height/2) + y) * 10
			
			var water_atlas_x = round(2 + 2 * (moist + 10) / 20)
			var water_atlas_y = round(2 * (temp + 10) / 20)
			var sand_atlas = Vector2i(5,1)
			var land_atlas_x = round(3 * (moist + 10) / 20)
			var land_atlas_y = round(3 * (temp + 10) / 20)
			
			if alt > 0:
				set_cell(1, Vector2i(pos.x - (width/2) + x, pos.y - (height/2) + y), 1, sand_atlas)
			else:
				set_cell(0, Vector2i(pos.x - (width/2) + x, pos.y - (height/2) + y), 0, Vector2(water_atlas_x,1))
				
			if Vector2i(pos.x, pos.y) not in _loaded_chunks:
				_loaded_chunks.append(Vector2i(pos.x, pos.y))

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
			set_cell(0, Vector2i(pos.x - (width/2) + x, pos.y - (height/2) + y), -1, Vector2(-1,-1))
				
func dist(p1,p2):
	var r = p1-p2
	return sqrt(r.x ** 2 + r.y ** 2)
	
	
func _place_scene(chunk_position: Vector2i, scene: PackedScene, density: float, parent: Node, scene_name: String):
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
	
