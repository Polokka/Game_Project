extends CharacterBody2D

#Restart testing variables
const MAIN_SCENE = preload("res://Scenes/main_scene.tscn")

# Basic movement variables
const SPEED = 1200.0
const JUMP_VELOCITY = -600.0
var maxFallSpeed = 1700.0  
var acceleration = 2300
var turn_acceleration = 3000
var friction = 1000
var input_direction = Vector2()

# Air movement variables
const DASH_SPEED = 800
var airDashAvailable = true
var dash_vector = Vector2.ZERO
var dashing_time = 0.25
const FAST_FALL_MULTIPLIER = 3 
var fast_falling = false

# RayCasts
@onready var ray_cast_2d_left: RayCast2D = $RayCast2DLeft
@onready var ray_cast_2d_right: RayCast2D = $RayCast2DRight
@onready var ray_cast_2d_side_left: RayCast2D = $RayCast2DSideLeft
@onready var ray_cast_2d_side_right: RayCast2D = $RayCast2DSideRight


# Animation variables
var speed = 100
var direction = Vector2.ZERO
var last_direction = Vector2.ZERO
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var idle_state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/Idle/playback")
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

# Collision
@onready var collisionShape: CollisionShape2D = $CollisionShape2D
const CAPSULE_COLLISION = preload("res://PlayerCharVariables/CapsuleCollision.tres")
const CIRCLE_COLLISION = preload("res://PlayerCharVariables/CircleCollision.tres")

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
				
				# Lower airfriction
			elif velocity.x > 1200 or velocity.x < -1200 and !is_on_floor() and sign(input_direction.x) == sign(velocity.x):
				velocity.x = move_toward(velocity.x, input_direction.x, friction * 0.3 * delta)
				
				# Lower groundfriction if high speed and same inputdirection
			elif velocity.x > 1200 or velocity.x < -1200 and is_on_floor() and sign(input_direction.x) == sign(velocity.x):
				velocity.x = move_toward(velocity.x, input_direction.x, friction * 0.6 * delta)
				
			else:
				# Basic acceleration
				velocity.x = move_toward(velocity.x, input_direction.x * SPEED, acceleration * delta)
		else:
			# Slowdown
			if is_on_floor():
				velocity.x = move_toward(velocity.x, 0, friction * delta)
			else:
				velocity.x = move_toward(velocity.x, 0, friction * 0.5 * delta)
	
	#Player rotation
	var smoothness = 0.08
	var target_rotation = null

	if ray_cast_2d_left.is_colliding() or ray_cast_2d_right.is_colliding():
		var normal_left = ray_cast_2d_left.get_collision_normal()
		var normal_right = ray_cast_2d_right.get_collision_normal()
		
		var avg_normal = (normal_left + normal_right) / 2
		avg_normal = avg_normal.normalized()
		target_rotation = avg_normal.angle() + PI / 2
		
		if ray_cast_2d_side_left.is_colliding() == false and ray_cast_2d_side_right.is_colliding() == false:
			rotation = lerp_angle(rotation, target_rotation, smoothness)
	else:
		target_rotation = 0
	if target_rotation == 0:
		rotation = lerp_angle(rotation, target_rotation, smoothness)

	move_and_slide()
	
	#Animation
	if abs(velocity.x) >= 1500 or abs(velocity.y) >= 1500 or abs(velocity.x + velocity.y) > 2000:
		movement_animation()
		collisionShape.shape = CIRCLE_COLLISION
	else:
		idle_animation(input_direction)
		collisionShape.shape = CAPSULE_COLLISION
	
	
	if Input.is_action_just_pressed("Reload Scene"):
		reloadScene()


func movement_animation():
	state_machine.travel("Ball Demo")
	if velocity.x < -500:
		last_direction = Vector2(-1, 0)
	elif velocity.x > 500:
		last_direction = Vector2(1, 0)

func idle_animation(animation_direction: Vector2) -> void:
	state_machine.travel("Idle")
	if velocity.x < -500:
		last_direction = Vector2(-1, 0)
		idle_state_machine.travel("Idle Left")
	elif velocity.x > 500:
		last_direction = Vector2(1, 0)
		idle_state_machine.travel("Idle Right")
	
	if animation_direction == Vector2.ZERO:
		if abs(velocity.x) < 100:
			animation_direction = last_direction
	
	if animation_direction.x > 0:
		last_direction = Vector2(1, 0)
		idle_state_machine.travel("Idle Right")
	if animation_direction.x < 0:
		last_direction = Vector2(-1, 0)
		idle_state_machine.travel("Idle Left")

func reloadScene():
	get_tree().change_scene_to_packed(MAIN_SCENE)
