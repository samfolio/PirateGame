extends Node2D

@export var scene_name: String = "IslandShop"

func _on_area_2d_body_entered(body):
	if body.has_method("player_shop_method"):
		print("OpenShop")
