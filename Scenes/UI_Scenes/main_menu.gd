extends Control

@onready var playButton: Button = $playButton



func _on_play_button_pressed() -> void:
	# 1. NewScene 2. Remove self from tree
	Globals.loadScene("res://Scenes/Stages/DemoStage.tscn", "/root/Main_Scene/MainMenu")
