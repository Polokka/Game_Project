extends RigidBody2D

var targetPosition = Vector2.ZERO
var speed = 6000  
var is_grappling = false
var is_hooked = false
var attached_to: Node = null
var player_body: CharacterBody2D = null
var hook_distance_to_player: float = 0.0
var target_distance = Vector2.ZERO
var other_hook: RigidBody2D = null
var playerSpeed = 3000
var audioPlayer = null

func grapple():
	is_grappling = true
	self.sleeping = false
	self.set_contact_monitor(true)
	self.set_max_contacts_reported(5)
	audioPlayer = get_tree().get_nodes_in_group("AudioPlayers")[0]
	audioPlayer.play()
	if is_grappling:
		is_grappling = false
		targetPosition = Vector2((Input.get_axis("Aim_Left", "Aim_Right") * 1.5), Input.get_axis("Aim_Up", "Aim_Down")).normalized()
		if targetPosition == Vector2.ZERO:
			var mouse_pos = get_global_mouse_position()
			targetPosition = (mouse_pos - global_position).normalized()
		apply_central_impulse(targetPosition * speed)

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("L2") and is_hooked:
		var _current_distance = global_position.distance_to(player_body.global_position)
		#if current_distance > hook_distance_to_player:
	if Input.is_action_just_released("L2"):
		self.queue_free()
		
func _on_tree_entered() -> void:
	Globals.playerGrapplingHook.connect(grapple)
	player_body = get_tree().get_nodes_in_group("Player")[0] as CharacterBody2D

func _on_tree_exiting() -> void:
	Globals.playerGrapplingHook.disconnect(grapple)
	other_hook = null
	audioPlayer.stop()
	
func _on_body_entered(body: Node) -> void:
	if body != player_body and body != other_hook:
		is_hooked = true
		attached_to = body
		self.sleeping = true
		hook_distance_to_player = global_position.distance_to(player_body.global_position)
		if player_body != null and body is TileMapLayer:
			pull_player_towards_hook()

func pull_player_towards_hook():
	var hook_position = global_position
	var player_position = player_body.global_position
	var direction_to_hook = (hook_position - player_position).normalized()
	
	player_body.velocity = direction_to_hook * playerSpeed
	
	target_distance = hook_position + direction_to_hook * hook_distance_to_player
	
	
