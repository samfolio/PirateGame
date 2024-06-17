extends CharacterBody2D

@export var speed = 100
@export var rotation_speed = 1.5

#Variables for controlling the movement
const max_speed = 150
const accel = 150
const friction = 0

#input variable
var input = Vector2.ZERO
var rotation_direction = 0

func _read():
	z_index = 1
	collision_layer = 1
	collision_mask = 2

# tells the shop to open if entering its area.
func player_shop_method():
		pass

func get_input():
	rotation_direction = Input.get_axis("ui_left", "ui_right")
	
	# If input is -1 go down. If input is 1 go up.
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up")) 
	return input.normalized()

func _process(delta):
	#Checks for the input direction.
	var playerInput = get_input()
	
	#if there is no input, then if the decrease the speed.
	if playerInput == Vector2.ZERO:
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

