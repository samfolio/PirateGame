extends CharacterBody2D


#Exports variable
@export var yes = 1
#roations vars
@export var speed = 400
@export var rotation_speed = 1.5



#Variables for controlling the movement
const max_speed = 50
const accel = 50
const friction = 20

#input variable
var input = Vector2.ZERO
var rotation_direction = 0

#runs when the game starts and runs our player_move func.
func _physics_process(delta):
	player_movement(delta)

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

