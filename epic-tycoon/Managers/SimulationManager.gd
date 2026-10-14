extends Node

var sim_timer: Timer
var game_speed: float = 1.0
var is_paused: bool = false
var ticks: int = 0

@export_category("Game Speed")
@export var pause: Button
@export var multi_01: Button
@export var multi_02: Button
@export var multi_03: Button
@export var speed_label: Label

@export_category("Misc.")
@export var ticks_label: Label
var ticks_str: String

func _ready() -> void:
	# Create the timer dynamically so you don't need a child node in the scene tree
	sim_timer = Timer.new()
	sim_timer.one_shot = false
	sim_timer.wait_time = 1.0
	sim_timer.timeout.connect(_on_simulation_tick)
	add_child(sim_timer)
	sim_timer.start()

func set_speed(multiplier: float) -> void:
	game_speed = multiplier
	if game_speed <= 0.0:
		sim_timer.paused = true
	else:
		sim_timer.paused = false
		sim_timer.wait_time = 1.0 / game_speed

func _on_simulation_tick() -> void:
	ticks = ticks + 1
	ticks_str = str(ticks)
	ticks_label.text = ticks_str
	

func _on_pause_button_pressed() -> void:
	game_speed = 0.0
	speed_label.text = "0.0"
	set_speed(game_speed)


func _on_multi_button_01_pressed() -> void:
	game_speed = 1.0
	speed_label.text = "1.0"
	set_speed(game_speed)


func _on_multi_button_02_pressed() -> void:
	game_speed = 2.0
	speed_label.text = "2.0"
	set_speed(game_speed)
	

func _on_multi_button_03_pressed() -> void:
	game_speed = 3.0
	speed_label.text = "3.0"
	set_speed(game_speed)
