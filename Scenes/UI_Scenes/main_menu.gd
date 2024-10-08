extends Control

var firstPress = true

func _on_play_button_pressed() -> void:
	# 1. NewScene 2. Remove self from tree
	if firstPress:
		firstPress = false
		Globals.loadMainScene("res://Scenes/Stages/Lvl1.tscn", "/root/Main_Scene/MainMenu")



func _on_quit_button_pressed() -> void:
	get_tree().quit()
