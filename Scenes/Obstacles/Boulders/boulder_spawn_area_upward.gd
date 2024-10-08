extends Node2D

#Variables
@onready var area_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var timer: Timer = $Timer
const boulder = preload("res://Scenes/Obstacles/Boulders/BoulderUpward.tscn")
var extents = null
var newBoulder = null

#Functions
func _ready() -> void:
	timer.connect("timeout", spawnBoulders)
	extents = area_2d.shape.size

func getRandomPoint() -> Vector2:
	return Vector2(
		randf_range(-extents.x, extents.x),
		randf_range(-extents.y, extents.y)
	)

func spawnBoulders():
	newBoulder = boulder.instantiate()
	var boulderPos = getRandomPoint()
	newBoulder.position = boulderPos
	add_child(newBoulder)
	
