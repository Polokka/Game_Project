extends Control

var firstPress = true
var lvl1Time = null
var lvl2Time = null
var lvl3Time = null

@onready var lvl1TimeLabel: RichTextLabel = $"Scores/Lvl 1"
@onready var lvl2TimeLabel: RichTextLabel = $"Scores/Lvl 2"
@onready var lvl3TimeLabel: RichTextLabel = $"Scores/Lvl 3"

func _ready() -> void:
	Globals.loadSavedData()
	
	if Globals.savedData.has("Lvl1"):
		lvl1TimeLabel.text = "Level 1: " + str(Globals.savedData["Lvl1"])
	if Globals.savedData.has("Lvl2"):
		lvl2TimeLabel.text = "Level 2: " + str(Globals.savedData["Lvl2"])
	if Globals.savedData.has("Lvl3"):
		lvl3TimeLabel.text = "Level 3: " + str(Globals.savedData["Lvl3"])
#Start game
func _on_play_button_pressed() -> void:
	# 1. NewScene 2. Remove self from tree
	if firstPress:
		firstPress = false
		Globals.loadMainScene("res://Scenes/Stages/Lvl1.tscn", "/root/Main_Scene/MainMenu")

#Select lvl
func _on_lvl_2_pressed() -> void:
	Globals.loadNextStage("Lvl1")
	
func _on_lvl_3_pressed() -> void:
	Globals.loadNextStage("Lvl2")

	
func _on_quit_button_pressed() -> void:
	get_tree().quit()
