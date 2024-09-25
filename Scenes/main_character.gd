extends CharacterBody2D

# Basic movement variables
const SPEED = 1200.0
const JUMP_VELOCITY = -600.0
var maxFallSpeed = 1700.0  
var acceleration = 2300
var turn_acceleration = 3000
var friction = 1400
var input_direction = Vector2()

# Air movement variables
const DASH_SPEED = 800
var airDashAvailable = true
var dash_vector = Vector2.ZERO
var dashing_time = 0.25
const FAST_FALL_MULTIPLIER = 3 
var fast_falling = false

# Animation variables
var speed = 100
var direction = Vector2.ZERO
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/Idle/playback")

func _physics_process(delta: float) -> void:
	var gravity_force = Globals.GRAVITY * delta
	
	if is_on_floor():
		airDashAvailable = true
		dash_vector = Vector2.ZERO
		fast_falling = false  # Palauta normaali tila lattialla
		dashing_time = 0.25

	# Add gravity when in air and not dashing
	if not is_on_floor() and dash_vector == Vector2.ZERO:
		if Input.is_action_pressed("Down"):
			fast_falling = true 
		elif fast_falling and not Input.is_action_pressed("Down"):
			fast_falling = false
			maxFallSpeed = 2000
		
		if fast_falling:
			maxFallSpeed = 3000
			gravity_force *= FAST_FALL_MULTIPLIER  # Nopeampi putoaminen
		velocity.y += gravity_force

	# Handle jump
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Handle airdash
	if Input.is_action_just_pressed("Jump") and airDashAvailable and not is_on_floor():
		airDashAvailable = false
		dash_vector = Vector2(Input.get_axis("Left", "Right"), Input.get_axis("Up", "Down")).normalized()
		
		if dash_vector == Vector2.ZERO:
			if velocity.x != 0: # Dashaa aiempaan liikesuuntaan
				dash_vector += Vector2(sign(velocity.x), 0)
			else:
				dash_vector += Vector2(1, 0)  # Dash oikealle, jos suuntaa ei ole annettu
			
		var horizontal_speed = dash_vector.x * DASH_SPEED * 1.8  # Horisontaalinen dash on voimakkaampi
		var vertical_speed = dash_vector.y * DASH_SPEED * 1.2    # Vertikaalinen dash on heikompi
		
		var min_dash_speed = 0.4
		var dash_speed_adjuster = 3000
		var adjusted_dash_x = horizontal_speed * max((1 - (abs(velocity.x) / dash_speed_adjuster)), min_dash_speed)
		var adjusted_dash_y = vertical_speed * max((1 - (abs(velocity.y) / dash_speed_adjuster)), min_dash_speed)
			
		#Nollaa velocity, jos dashin suunta muuttaa
		if sign(dash_vector.x) != sign(velocity.x) and dash_vector.x != 0:
			velocity.x = horizontal_speed
		else:
			velocity.x += adjusted_dash_x
		if sign(dash_vector.y) != sign(velocity.y) and dash_vector.y != 0:
			velocity.y = vertical_speed
		else:
			velocity.y += adjusted_dash_y


	# Stopping the dash
	if dashing_time > 0 and !airDashAvailable:
		dashing_time -= delta
	if dashing_time <= 0:
		dash_vector = Vector2.ZERO
		
	# Movement on x axis
	if dash_vector == Vector2.ZERO:
		input_direction.x = Input.get_axis("Left", "Right")
	
		if input_direction != Vector2.ZERO:
			if sign(input_direction.x) != sign(velocity.x) and velocity.x != 0:
				# Turnaround
				velocity.x = move_toward(velocity.x, input_direction.x * SPEED, turn_acceleration * delta)
				
			elif velocity.x > 1200 or velocity.x < -1200 and !is_on_floor():
				velocity.x = move_toward(velocity.x, input_direction.x, friction * 0.5 * delta)
				
			else:
				# Basic acceleration
				velocity.x = move_toward(velocity.x, input_direction.x * SPEED, acceleration * delta)
		else:
			# Slowdown
			if is_on_floor():
				velocity.x = move_toward(velocity.x, 0, friction * delta)
			else:
				velocity.x = move_toward(velocity.x, 0, friction * 0.5 * delta)
			
	move_and_slide()
	update_animation(input_direction)
	
	#Sliding things
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		print("Collided with: ", collision.get_collider())
	
	if Input.is_action_just_pressed("Reload Scene"):
		reloadScene()
		
func update_animation(animation_direction: Vector2) -> void:
	if animation_direction.x > 0:
		state_machine.travel("Idle Right")
	if animation_direction.x < 0:
		state_machine.travel("Idle Left")

func reloadScene():
	get_tree().reload_current_scene()
