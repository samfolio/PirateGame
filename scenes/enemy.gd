extends Node2D

var speed = 100
var player = null

func _ready():
	# Find the player node
	player = get_parent().get_node("Player")

func _process(delta):
	if player:
		var direction = (player.position - position).normalized()
		position += direction * speed * delta
