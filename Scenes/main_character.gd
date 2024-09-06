extends CharacterBody2D

#Basic movement variables

const SPEED = 400.0
const JUMP_VELOCITY = -600.0
const MAX_FALL_SPEED = 1000.0  
var acceleration = 1300
var turn_acceleration = 3000
var friction = 2200

#Air movement variables
const DASH_SPEED = 600
const DASH_DURATION = 0.15
var airDashAvaible = true
var dash_vector = Vector2.ZERO
var dashing_time = 0.0

const MAIN_SCENE = preload("res://Scenes/main_scene.tscn")



func _physics_process(delta: float) -> void:
	
	if is_on_floor():
		airDashAvaible = true
		dash_vector = Vector2.ZERO
		
	# Add the gravity.
	if not is_on_floor() and dash_vector == Vector2.ZERO:
		velocity.y += Globals.GRAVITY * delta
		if velocity.y > MAX_FALL_SPEED:
			velocity.y = MAX_FALL_SPEED

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	#Handle airdash.
	if Input.is_action_just_pressed("Jump") and airDashAvaible and !is_on_floor():
		airDashAvaible = false
		dashing_time = DASH_DURATION
		dash_vector = Vector2(Input.get_axis("Left", "Right"), Input.get_axis("Up", "Down")).normalized()

		if dash_vector == Vector2.ZERO:
			dash_vector += Vector2(1, 0) # Dash oikealle, jos suuntaa ei ole annettu
			
		var horizontal_speed = dash_vector.x * DASH_SPEED * 1.8  # Horisontaalinen dash on voimakkaampi
		var vertical_speed = dash_vector.y * DASH_SPEED * 1.2    # Vertikaalinen dash on heikompi
		velocity += Vector2(horizontal_speed, vertical_speed)

	#Stopping the dash
	if dashing_time > 0:
		dashing_time -= delta
	else:
		dash_vector = Vector2.ZERO
		
	# Movement on x axis
	if dash_vector == Vector2.ZERO:
		var input_direction = Vector2()
		input_direction.x = Input.get_axis("Left", "Right")
	
		if input_direction != Vector2.ZERO:
			if sign(input_direction.x) != sign(velocity.x) and velocity.x != 0:
				# Turnaround
				velocity.x = move_toward(velocity.x, input_direction.x * SPEED, turn_acceleration * delta)
			else:
				# Basic acceleration
				velocity.x = move_toward(velocity.x, input_direction.x * SPEED, acceleration * delta)
		else:
			#Slowdown
			velocity.x = move_toward(velocity.x, 0, friction * delta)
	move_and_slide()
	
	if Input.is_action_just_pressed("Reload Scene"):
		reloadScene()
	
func reloadScene():
	get_tree().change_scene_to_packed(MAIN_SCENE)
	

	
