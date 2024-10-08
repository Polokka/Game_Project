extends Node2D

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.connect("timeout", deleteSelf)

func deleteSelf():
	self.queue_free()
