extends Node

const GRAVITY = 1700.0

# Ablities
signal playerGrapplingHook
signal playerPunchingFistL
signal resetPlayer

#Obstacles

# Scenen vaihto
const ABLITIES = preload("res://Scenes/Player_Scenes/ablities.tscn")
const PLAYER = preload("res://Scenes/Player_Scenes/player.tscn")
var animPlayer = null
var audioPlayer = null
var scene_resource = null
var lvlMusic = preload("res://Sounds/PractiseProjectJungle.wav")


#Levels
var nextScenePath = null
var nextScene = {
	"Lvl1": "res://Scenes/Stages/Lvl2.tscn",
	"Lvl2": "res://Scenes/Stages/Lvl3.tscn"
}

#Finishing the level
signal finish
var openNextStage = false
var playerFinished = false
var nextStage = null
var lastStage = null
var onlyOneFanfare = false
var fanfare = preload("res://Sounds/FinishFanfare.wav")

func _ready() -> void:
	finish.connect(finishFanfare)


func loadMainScene(newScene: String, oldScene: String) -> void:
	animPlayer = get_node("/root/Main_Scene/CloseSceneAnim/AnimationPlayer")
	animPlayer.play("IrisClosing")
	lastStage = get_node(oldScene)
	var player_resource = PLAYER.instantiate()
	var ablities_resource = ABLITIES.instantiate()
	scene_resource = ResourceLoader.load(newScene)
	var mainScene = get_node("/root/Main_Scene")
	if scene_resource:
		var newSceneResource = scene_resource.instantiate()
		await animPlayer.animation_finished
		lastStage.queue_free()
		animPlayer.play("IrisOpening")
		if not mainScene.has_node("Player"):
			mainScene.add_child(player_resource)
		if not mainScene.has_node("Ablities"):
			mainScene.add_child(ablities_resource)
		
		mainScene.add_child(newSceneResource)

func loadNextStage(oldStage: String):
	audioPlayer = get_node("/root/Main_Scene/Player/Camera2D/Music")
	animPlayer = get_node("/root/Main_Scene/CloseSceneAnim/AnimationPlayer")
	animPlayer.play("IrisClosing")
	var mainScene = get_node("/root/Main_Scene")
	lastStage = mainScene.get_node(oldStage)
	nextScenePath = nextScene.get(oldStage, null)
	scene_resource = ResourceLoader.load(nextScenePath)
	if scene_resource:
		var newSceneResource = scene_resource.instantiate()
		await animPlayer.animation_finished
		lastStage.queue_free()
		animPlayer.play("IrisOpening")
		mainScene.add_child(newSceneResource)
		resetPlayer.emit()
		audioPlayer.stream = lvlMusic
		audioPlayer.play()
		openNextStage = false
		onlyOneFanfare = false
		
func finishFanfare():
	audioPlayer = get_node("/root/Main_Scene/Player/Camera2D/Music")
	if onlyOneFanfare == false:
		onlyOneFanfare = true
		audioPlayer.stream = fanfare
		audioPlayer.play()
