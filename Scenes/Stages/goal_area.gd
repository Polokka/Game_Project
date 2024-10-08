extends Area2D




func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Globals.finish.emit()
		Globals.openNextStage = true
		

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("NextLvl") and Globals.openNextStage:
		var current_scene = get_parent().name
		Globals.loadNextStage(current_scene)
