extends Area2D

var timer = null


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		timer = get_parent().get_parent().get_node("Player/UI/CanvasLayer/Opacity/TimerUI/TimerLabel")
		var time = float(timer.text)
		Globals.finish.emit()
		Globals.openNextStage = true
		var currentLvl = get_parent().name
		Globals.wasItHighScore(currentLvl, time)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("NextLvl") and Globals.openNextStage:
		var currentLvl = get_parent().name
		Globals.loadNextStage(currentLvl)
