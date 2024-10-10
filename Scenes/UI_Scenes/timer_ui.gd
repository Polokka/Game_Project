extends Node

@onready var timer: Timer = $Timer
@onready var timer_label: Label = $TimerLabel

var timePassed = 0
var finish = true
var timerStarted = false

func _ready() -> void:
	Globals.finish.connect(stopTimer)

func _input(event: InputEvent) -> void:
	if not timerStarted and not (event is InputEventMouseMotion):
		if not Input.is_action_pressed("Restart") and not Input.is_action_just_released("Restart"):
			timerStarted = true
			timer.start()
			finish = false
		

func _on_timer_timeout():
	if timerStarted and not finish:
		timePassed += 0.1
		timer_label.text ="%.1f" % timePassed

func stopTimer():
	timer.stop()
	finish = true

func resetTimer():
	timerStarted = false
	timePassed = 0
	timer.stop()
	timer_label.text = "0.0"
	finish = true
