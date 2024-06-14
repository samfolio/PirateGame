extends CharacterBody2D



@export var speed = 400
@export var rotation_speed = 1.5
@export var tilemap: TileMap
@export var water_atlas_coord: Vector2i = Vector2i(6,3)
@export var base_layer: int = -1
@export var chunk_size: Vector2i = Vector2i(32, 32)
@export var view_radius: int = 2
@export var island_density = 0.01
@export var enemy_density = 0.05
@export var rock_density = 0.02
@export var island_scene: PackedScene
@export var enemy_scene: PackedScene
@export var rock_scene: PackedScene

# initializes initial last_chunk_position
var last_chunk_position = Vector2i(0,0)

#Variables for controlling the movement
const max_speed = 150
const accel = 150
const friction = 0

#input variable
var input = Vector2.ZERO
var rotation_direction = 0

# set to keep track of occupied positions
var occupied_positions = {}

func _ready():
	if tilemap == null:
		print("Tilemap not assigned")
		return
	print("BaseTileMap assigned")
	# Initialize first chunk
	_generate_chunks_around_player()

func _physics_process(delta):
	if tilemap == null:
		return
	var current_chunk_position = world_to_chunk(global_position)
	if current_chunk_position != last_chunk_position:
		print("Player moved to a new chunk: ", current_chunk_position)
		last_chunk_position = current_chunk_position
		_generate_chunks_around_player()
	player_movement(delta)

func world_to_chunk(world_position: Vector2) -> Vector2i:
	if tilemap == null:
		return Vector2i()
	var chunk_x = int(world_position.x / (tilemap.tile_set.tile_size.x * chunk_size.x))
	var chunk_y = int(world_position.y / (tilemap.tile_set.tile_size.y * chunk_size.y))
	# print("World position: ", world_position, " converted to chunk: ", Vector2i(chunk_x, chunk_y))
	return Vector2i(chunk_x, chunk_y)

func _generate_chunks_around_player():
	if tilemap == null:
		return
	var player_chunk_position = world_to_chunk(global_position)
	for x in range(player_chunk_position.x - view_radius, player_chunk_position.x + view_radius + 1):
		for y in range(player_chunk_position.y - view_radius, player_chunk_position.y + view_radius + 1):
			# print("Generating chunk at: (", x, ",", y, ")")
			_generate_chunk(Vector2i(x,y))

func _generate_chunk(chunk_position: Vector2i):
	if tilemap == null:
		return
	var num_tiles_placed = 0
	var start_position = chunk_position * chunk_size
	print("Generating chunk at: ", chunk_position, " starting at position: ", start_position)
	for x in range(chunk_size.x):
		for y in range(chunk_size.y):
			var tile_position = start_position + Vector2i(x, y)
			# print("Checking tile position: ", tile_position)
			if tilemap.get_cell_source_id(-1, tile_position) == -1:
				# print("Setting water tile at: ", tile_position)
				tilemap.set_cell(base_layer, tile_position, 0, water_atlas_coord)
				num_tiles_placed += 1
			#else:
				#print("Tile already exists at: ", tile_position)
	print("Finished generating chunks at: ", chunk_position, " starting at positin: ", start_position, " placed: ", num_tiles_placed, " tiles...")
	
	# place islands
	_place_scene(chunk_position, island_scene, island_density)
	
	#place enemies
	_place_scene(chunk_position, enemy_scene, enemy_density)
	#_place_islands_and_enemies(chunk_position)
	
	_place_scene(chunk_position, rock_scene, rock_density)
	
	
func _place_scene(chunk_position: Vector2i, scene: PackedScene, density: float):
	var start_position = chunk_position * chunk_size
	var end_position = start_position + chunk_size
	
	# place a scene
	for i in range(chunk_size.x * chunk_size.y * density):
		var scene_position = start_position + Vector2i(randf_range(0, chunk_size.x), randf_range(0, chunk_size.y)) * tilemap.tile_set.tile_size
		if not is_position_occupied(scene_position):
			var scene_instance = scene.instantiate()
			scene_instance.position = scene_position * tilemap.tile_set.tile_size
			tilemap.add_child(scene_instance)
			occupied_positions[scene_position] = true
			print("Placing scene @", scene_instance.position)
	
		
func is_position_occupied(position: Vector2) -> bool:
	return position in occupied_positions

#tells the shop to open if entering its area.
func player_shop_method():
		pass

func get_input():
	rotation_direction = Input.get_axis("ui_left", "ui_right")
	#velocity = transform.x * Input.get_axis("ui_down", "ui_up") * speed
	#If input is -1 go down. If input is 1 go up.
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up")) 
	return input.normalized()

func player_movement(delta):
	#Checks for the input direction.
	input = get_input()
	
	#if there is no input, then if the decrease the speed.
	if input == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (friction * delta)
		else:
			#if the speed is less than the friction speed. set the speed to 0.
			velocity = Vector2.ZERO
	else:
		#else use the input to speed up in the direction it is pointing.
		velocity += (transform.x * Input.get_axis("ui_down", "ui_up") * accel * delta)
		velocity = velocity.limit_length(max_speed)
	
	#rotate the ship based on the direction input.
	rotation += rotation_direction * rotation_speed * delta
	
	#move an slide allows us to slide.
	move_and_slide()
	
	#git commit test. My issues need tissues.

