extends Camera2D

var min_zoom = 0.1
var max_zoom = 1.5
var zoom_speed = 5
var zoom_factor = 0.1
var target_zoom = Vector2.ZERO

func _ready() -> void:
	zoom = Vector2(0.3, 0.3)
	target_zoom = zoom

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_zoom = clamp(target_zoom * (1 + zoom_factor), Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_zoom = clamp(target_zoom * (1 - zoom_factor), Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))

func _process(delta: float) -> void:
	zoom = zoom.lerp(target_zoom, zoom_speed * delta)
