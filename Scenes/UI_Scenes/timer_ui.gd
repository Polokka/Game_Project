extends Node

@onready var timer: Timer = $Timer
@onready var timer_label: Label = $TimerLabel

var timePassed = 0
var finish = true

func _ready() -> void:
	Globals.finish.connect(stopTimer)

func _on_timer_timeout():
	
	timePassed += 0.1
	timer_label.text = "Timer: " + "%.1f" % timePassed

func stopTimer():
	timer.stop()
