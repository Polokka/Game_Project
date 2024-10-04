extends Node

const GRAVITY = 1700.0

# Ablities
signal playerGrapplingHook
signal playerPunchingFistL

# Scenen vaihto
const ABLITIES = preload("res://Scenes/Player_Scenes/ablities.tscn")
const PLAYER = preload("res://Scenes/Player_Scenes/player.tscn")
var animPlayer = null

#Finishing the level
signal finish
var playerFinished = false


func loadMainScene(newScene: String, oldScene: String) -> void:
	animPlayer = get_node("/root/Main_Scene/CloseSceneAnim/AnimationPlayer")
	animPlayer.play("IrisClosing")
	var lastScene = get_node(oldScene)
	var player_resource = PLAYER.instantiate()
	var ablities_resource = ABLITIES.instantiate()
	var scene_resource = ResourceLoader.load(newScene)
	var mainScene = get_node("/root/Main_Scene")
	if scene_resource:
		var new_scene = scene_resource.instantiate()
		await animPlayer.animation_finished
		lastScene.queue_free()
		animPlayer.play("IrisOpening")
		if not mainScene.has_node("Player"):
			mainScene.add_child(player_resource)
		if not mainScene.has_node("Ablities"):
			mainScene.add_child(ablities_resource)
		
		mainScene.add_child(new_scene)
		
