extends CharacterBody2D

@export var scene_name: String = "Enemy"

var speed = 100
var player = null

func _ready():
	# Find the player node
	player = get_parent().get_node("Player")

func _process(delta):
	if player:
		var direction = (player.position - position).normalized()
		velocity = direction * speed
		move_and_slide()
