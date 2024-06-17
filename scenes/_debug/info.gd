extends CanvasLayer

@onready var player = get_tree().current_scene.get_node("Player")
@onready var global_pos: Label = $"InfoBox/Global Position"
@onready var chunk_address: Label = $"InfoBox/Chunk Address"

var chunk_width: int = 64
var chunk_height: int = 64

func _ready() -> void:
	if OS.is_debug_build() or Engine.is_editor_hint():
		global_pos.visible = true
		chunk_address.visible = true
	else:
		global_pos.visible = false
		chunk_address.visible = false

func _process(delta):
	if OS.is_debug_build() or Engine.is_editor_hint():
		update_debug_text()

func update_debug_text():
	var player_pos: Vector2 = player.global_position
	
	var chunk_x: int = int(player_pos.x / chunk_width)
	var chunk_y: int = int(player_pos.x / chunk_height)
	
	global_pos.text = "Player Position: (%.2f, %.2f)" % [player_pos.x, player_pos.y]
	chunk_address.text = "Chunk: (%d, %d)" % [chunk_x, chunk_y]
