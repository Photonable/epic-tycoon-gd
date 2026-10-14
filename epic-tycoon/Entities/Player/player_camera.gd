extends Camera3D

@export var min_zoom: float = 8.0     # Maximum zoom IN (smallest size)
@export var max_zoom: float = 60.0    # Maximum zoom OUT (largest size)
@export var zoom_step: float = 3.0    # How much to zoom per scroll wheel tick
@export var zoom_smoothness: float = 12.0 # Speed of the smooth zoom interpolation

@onready var target_size: float = size

func _ready() -> void:
	# Ensure the camera is actually set to Orthographic mode
	projection = Camera3D.PROJECTION_ORTHOGONAL
	target_size = size

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			# Scroll UP -> Zoom IN -> Decrease orthographic size
			target_size -= zoom_step
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			# Scroll DOWN -> Zoom OUT -> Increase orthographic size
			target_size += zoom_step
		
		# Clamp to prevent going below zero or zooming out endlessly
		target_size = clampf(target_size, min_zoom, max_zoom)

func _process(delta: float) -> void:
	# Smoothly transition current size toward the target size
	size = lerpf(size, target_size, zoom_smoothness * delta)
