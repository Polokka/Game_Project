extends Control

var firstPress = true

func _on_play_button_pressed() -> void:
	# 1. NewScene 2. Remove self from tree
	if firstPress:
		firstPress = false
		Globals.loadMainScene("res://Scenes/Stages/DemoStage.tscn", "/root/Main_Scene/MainMenu")
