extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1)
	tween.tween_property(self, "modulate:a", 1, 1)
