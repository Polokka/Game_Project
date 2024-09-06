extends Node

#Grappling Hook things
@onready var player: CharacterBody2D = $"../Player"

var grappling_hook_scene: PackedScene = preload("res://Scenes/grappling_hook.tscn")
var grappling_hook_scene_R: PackedScene = preload("res://Scenes/grappling_hook_r.tscn")
var grapplingHook: RigidBody2D = null
var grapplingHook_R: RigidBody2D = null

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

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("GrappleHook"):
		fireGrapplingHook()
	if Input.is_action_just_pressed("GrappleHook_R"):
		fireGrapplingHook_R()
