extends Node

#General variables
@onready var player: CharacterBody2D = $"../Player"
var abilities_array_l = ["GrapplingHook", "PushingFist"]
var current_ability_l = abilities_array_l[0]
var abilities_array_r = ["GrapplingHook", "PushingFist"]
var current_ability_r = abilities_array_r[0]

#Grappling Hook things
var grappling_hook_scene: PackedScene = preload("res://Scenes/grappling_hook.tscn")
var grappling_hook_scene_R: PackedScene = preload("res://Scenes/grappling_hook_r.tscn")
var grapplingHook: RigidBody2D = null
var grapplingHook_R: RigidBody2D = null

#Punching Fist things
var punching_fist_scene_l: PackedScene = preload("res://Scenes/punching_fist_l.tscn")
var punchingFistL: RigidBody2D = null
var punching_fist_scene_r: PackedScene = preload("res://Scenes/punching_fist_r.tscn")
var punchingFistR: RigidBody2D = null

#Swap ability
func swap_ability_l():
	var current_index = abilities_array_l.find(current_ability_l)
	if current_index != -1:
		var next_index = (current_index + 1) % abilities_array_l.size()
		current_ability_l = abilities_array_l[next_index]
		print("Uusi kyky:", current_ability_l)
	else:
		print("Nykyinen kyky ei löydy taulukosta")

func swap_ability_r():
	var current_index = abilities_array_r.find(current_ability_r)
	if current_index != -1:
		var next_index = (current_index + 1) % abilities_array_r.size()
		current_ability_r = abilities_array_r[next_index]
		print("Uusi kyky:", current_ability_r)
	else:
		print("Nykyinen kyky ei löydy taulukosta")
		
#PushingFist functions
func firePunchingFistL():
	if punchingFistL == null and (Input.get_axis("Aim_Left", "Aim_Right") != 0 or Input.get_axis("Aim_Up", "Aim_Down") != 0):
		punchingFistL = punching_fist_scene_l.instantiate()
		add_child(punchingFistL)
		punchingFistL.global_position = player.global_position
		Globals.playerPunchingFistL.emit()
		
func firePunchingFistR():
	if punchingFistR == null and (Input.get_axis("Aim_Left", "Aim_Right") != 0 or Input.get_axis("Aim_Up", "Aim_Down") != 0):
		punchingFistR = punching_fist_scene_r.instantiate()
		add_child(punchingFistR)
		punchingFistR.global_position = player.global_position
		Globals.playerPunchingFistR.emit()

#Grappling functions
func fireGrapplingHook():
	if grapplingHook == null and (Input.get_axis("Aim_Left", "Aim_Right") != 0 or Input.get_axis("Aim_Up", "Aim_Down") != 0):
		grapplingHook = grappling_hook_scene.instantiate()
		add_child(grapplingHook)
		grapplingHook.global_position = player.global_position
		#grapplingHook.global_position = global_position
		Globals.playerGrapplingHook.emit()

func fireGrapplingHook_R():
	if grapplingHook_R == null and (Input.get_axis("Aim_Left", "Aim_Right") != 0 or Input.get_axis("Aim_Up", "Aim_Down") != 0):
		grapplingHook_R = grappling_hook_scene_R.instantiate()
		add_child(grapplingHook_R)
		grapplingHook_R.global_position = player.global_position
		Globals.playerGrapplingHook_R.emit()

#Choose ability based on player inputs
func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("Swap_Ability_L"):
		swap_ability_l()
	if Input.is_action_just_pressed("Swap_Ability_R"):
		swap_ability_r()
	
	if Input.is_action_just_pressed("L2"):
		match current_ability_l:
			"GrapplingHook":
				fireGrapplingHook()
			"PushingFist":
				firePunchingFistL()
			
	if Input.is_action_just_pressed("R2"):
		match current_ability_r:
			"GrapplingHook":
				fireGrapplingHook_R()
			"PushingFist":
				firePunchingFistR()
