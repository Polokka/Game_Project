extends RigidBody2D

var targetPosition = Vector2.ZERO
var speed = 1800  
var is_punching = false
var is_punched = false
var attached_to: Node = null
var player_body: CharacterBody2D = null
var hook_distance_to_player: float = 0.0
var target_distance = Vector2.ZERO
var other_hook: RigidBody2D = null

func punch():
	is_punching = true
	self.sleeping = false
	self.set_contact_monitor(true)
	self.set_max_contacts_reported(5)
	if is_punching:
		is_punching = false
		targetPosition = Vector2(Input.get_axis("Aim_Left", "Aim_Right"), Input.get_axis("Aim_Up", "Aim_Down")).normalized()
		apply_central_impulse(targetPosition * speed)

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("L2") and is_punching:
		var _current_distance = global_position.distance_to(player_body.global_position)
		#if current_distance > hook_distance_to_player:
	if Input.is_action_just_released("L2"):
		self.queue_free()
		
func _on_tree_entered() -> void:
	Globals.playerPunchingFistL.connect(punch)
	player_body = get_parent().get_parent().get_node("Player") as CharacterBody2D

func _on_tree_exiting() -> void:
	Globals.playerPunchingFistL.disconnect(punch)
	other_hook = null
	
func _on_body_entered(body: Node) -> void:
	if body != player_body and body != other_hook:
		is_punched = true
		attached_to = body
		self.sleeping = true
		hook_distance_to_player = global_position.distance_to(player_body.global_position)
		if player_body != null:
			push_player_away()

func push_player_away():
	var fist_position = global_position
	var player_position = player_body.global_position
	var direction_to_hook = (fist_position - player_position).normalized()
	
	player_body.velocity = -direction_to_hook * speed
	
	target_distance = fist_position + direction_to_hook * hook_distance_to_player
	
