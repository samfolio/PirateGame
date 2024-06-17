extends Node2D

@onready var player = get_tree().current_scene.get_node("Player")

func _on_area_2d_body_entered(body):
	if body == player:
		print("OpenShop")
