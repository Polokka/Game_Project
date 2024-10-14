extends Node

const GRAVITY = 1700.0

# Ablities
signal playerGrapplingHook
signal playerPunchingFistL
signal resetPlayer

#Obstacles

#Scores
var timer = "root/Main_Scene/Player/UI/CanvasLayer/Opacity/TimerUI/TimerLabel"
var savedData = {}
var savePath = "user://IlkanPeliScoret.savegame.dat"
var lvl1Time = 0
var lvl2Time = 0
var lvl3Time = 0


# Scenen vaihto
const ABLITIES = preload("res://Scenes/Player_Scenes/ablities.tscn")
const PLAYER = preload("res://Scenes/Player_Scenes/player.tscn")
var animPlayer = null
var audioPlayer = null
var scene_resource = null
var lvlMusic = preload("res://Sounds/PractiseProjectJungle.wav")
@onready var mainScene = get_node("/root/Main_Scene")

#Levels
var nextScenePath = null
var nextScene = {
	"Lvl1": "res://Scenes/Stages/Lvl2.tscn",
	"Lvl2": "res://Scenes/Stages/Lvl3.tscn",
	"Lvl3": "res://Scenes/UI_Scenes/main_menu.tscn"
}

#Finishing the level
signal finish
var openNextStage = false
var playerFinished = false
var nextStage = null
var lastStage = null
var onlyOneFanfare = false
var fanfare = preload("res://Sounds/FinishFanfare.wav")
var musicPosition = 0

func _ready() -> void:
	finish.connect(finishFanfare)


func loadMainScene(newScene: String, oldScene: String) -> void:
	animPlayer = get_node("/root/Main_Scene/CloseSceneAnim/AnimationPlayer")
	mainScene = get_node("/root/Main_Scene")
	closeIris()
	lastStage = get_node(oldScene)
	var player_resource = PLAYER.instantiate()
	var ablities_resource = ABLITIES.instantiate()
	scene_resource = ResourceLoader.load(newScene)
	if scene_resource:
		var newSceneResource = scene_resource.instantiate()
		await animPlayer.animation_finished
		lastStage.queue_free()
		openIris()
		if not mainScene.has_node("Player"):
			mainScene.add_child(player_resource)
		if not mainScene.has_node("Ablities"):
			mainScene.add_child(ablities_resource)
		
		mainScene.add_child(newSceneResource)

func loadNextStage(oldStage: String):
	mainScene = get_node("/root/Main_Scene")
	animPlayer = get_node("/root/Main_Scene/CloseSceneAnim/AnimationPlayer")
	closeIris()
	if mainScene.has_node("MainMenu"):
		lastStage = mainScene.get_node("MainMenu")
	else:	
		lastStage = mainScene.get_node(oldStage)
	nextScenePath = nextScene.get(oldStage, null)
	scene_resource = ResourceLoader.load(nextScenePath)
	if scene_resource:
		var newSceneResource = scene_resource.instantiate()
		await animPlayer.animation_finished
		if lastStage:
			lastStage.queue_free()
		openIris()
		mainScene.add_child(newSceneResource)
		if not mainScene.has_node("Player"):
			var player_resource = PLAYER.instantiate()
			mainScene.add_child(player_resource)
		if not mainScene.has_node("Ablities"):
			var ablities_resource = ABLITIES.instantiate()
			mainScene.add_child(ablities_resource)
		if oldStage == "Lvl3":
			var player = get_node("/root/Main_Scene/Player")
			player.queue_free()
			var abilities = get_node("/root/Main_Scene/Ablities")
			abilities.queue_free()
		resetPlayer.emit()
		audioPlayer = get_node("/root/Main_Scene/Player/Camera2D/Music")
		audioPlayer.stream = lvlMusic
		audioPlayer.play(musicPosition)
		openNextStage = false
		onlyOneFanfare = false

func closeIris():
	animPlayer = get_node("/root/Main_Scene/CloseSceneAnim/AnimationPlayer")
	animPlayer.play("IrisClosing")
	
func openIris():
	animPlayer = get_node("/root/Main_Scene/CloseSceneAnim/AnimationPlayer")
	animPlayer.play("IrisOpening")
	
func finishFanfare():
	audioPlayer = get_node("/root/Main_Scene/Player/Camera2D/Music")
	if onlyOneFanfare == false:
		musicPosition = audioPlayer.get_playback_position()
		onlyOneFanfare = true
		audioPlayer.stream = fanfare
		audioPlayer.play()

func wasItHighScore(lvl, newTime: float):
	var savedTime = loadData(lvl)
	if savedTime != null:
		if savedTime > newTime or savedTime == 0:
			saveTime(lvl, newTime)
	else:
		saveTime(lvl, newTime)
		
func saveTime(lvl, time):
	loadSavedData()
	savedData[lvl] = time
	var file = FileAccess.open(savePath, FileAccess.ModeFlags.WRITE)
	file.store_var(savedData)
	file.close()

func loadData(lvl):
	loadSavedData()
	if savedData.has(lvl):
		return savedData[lvl]
	else:
		return null
		
		
func loadSavedData():
	if FileAccess.file_exists(savePath):
		var file = FileAccess.open(savePath, FileAccess.ModeFlags.READ)
		savedData = file.get_var()
		file.close()
	else:
		savedData = {}

func resetTimes():
	saveTime("Lvl1", 0)
	saveTime("Lvl2", 0)
	saveTime("Lvl3", 0)
	
