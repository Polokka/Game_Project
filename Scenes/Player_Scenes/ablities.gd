extends Node

#General variables
@onready var player: CharacterBody2D = $"../Player"
var abilities_array_l = ["GrapplingHook", "PushingFist"]
var current_ability_l = abilities_array_l[0]

#Grappling Hook things
const grappling_hook_scene = preload("res://Scenes/Player_Scenes/grappling_hook.tscn")
var grapplingHook: RigidBody2D = null

#Punching Fist things
var punching_fist_scene_l: PackedScene = preload("res://Scenes/Player_Scenes/punching_fist_l.tscn")
var punchingFistL: RigidBody2D = null

#Swap ability
func swap_ability_l():
	var current_index = abilities_array_l.find(current_ability_l)
	if current_index != -1:
		var next_index = (current_index + 1) % abilities_array_l.size()
		current_ability_l = abilities_array_l[next_index]

#PushingFist functions
func firePunchingFistL(mouseR):
	if punchingFistL == null and (Input.get_axis("Aim_Left", "Aim_Right") != 0 or Input.get_axis("Aim_Up", "Aim_Down") != 0) or mouseR:
		punchingFistL = punching_fist_scene_l.instantiate()
		add_child(punchingFistL)
		punchingFistL.global_position = player.global_position
		Globals.playerPunchingFistL.emit()
		
#Grappling functions
func fireGrapplingHook(mouseL):
	if grapplingHook == null and (Input.get_axis("Aim_Left", "Aim_Right") != 0 or Input.get_axis("Aim_Up", "Aim_Down") != 0) or mouseL:
		grapplingHook = grappling_hook_scene.instantiate()
		add_child(grapplingHook)
		grapplingHook.global_position = player.global_position
		Globals.playerGrapplingHook.emit()

#Choose ability based on player inputs
func _process(_delta: float) -> void:
	
	#if Input.is_action_just_pressed("Swap_Ability_L"):
		#swap_ability_l()
	
	if Input.is_action_just_pressed("MouseL"):
		match current_ability_l:
			"GrapplingHook":
				fireGrapplingHook(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT))
			"PushingFist":
				firePunchingFistL(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT))
	
	if Input.is_action_just_pressed("MouseR"):
				firePunchingFistL(Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT))
