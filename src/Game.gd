extends Node

export var high_score = 0
export var current_score = 0
export var is_running = false
export var restart_delay = 1.5

export var max_spawn_interval = 2.0 # maximum time allowed between spawns (in seconds)
export var min_spawn_interval = 0.5 # minimum time allowed between spawns (in seconds)
export var spawn_interval_change_rate = 0.05 # time between spawns decreases at this rate per second
export var min_enemy_speed = 30 # minimum speed enemies fly at (pixels/second)
export var max_enemy_speed = 60 # maximum speed enemies fly at (pixels/second)
export var speed_increase_increment = 1 # how much the speed is increased by at once
export var speed_increase = 3 # number of seconds between speed increases
export var current_enemy_speed = 0
export var current_spawn_interval = 0

export var min_spotlight_interval = 3.0
export var max_spotlight_interval = 6.0
export var spotlight_speed = 40

var time_since_enemy_speed_increase = 0.0
var restart_delay_time = 0.0

onready var plane = preload("res://Plane.tscn")

func _physics_process(delta):
	if not is_running:
		if restart_delay_time < restart_delay:
			restart_delay_time += delta
		return
	
	current_spawn_interval = clamp(current_spawn_interval - spawn_interval_change_rate * delta, min_spawn_interval, max_spawn_interval)
	time_since_enemy_speed_increase += delta
	if time_since_enemy_speed_increase > speed_increase:
		time_since_enemy_speed_increase = 0.0
		current_enemy_speed = clamp(current_enemy_speed + speed_increase_increment, min_enemy_speed, max_enemy_speed)

func _input(event):
	if is_running or restart_delay_time < restart_delay:
		return
	
	if event.is_action_pressed("fire"):
		start_game()

func start_game():
	create_player()
	
	current_spawn_interval = max_spawn_interval
	current_enemy_speed = min_enemy_speed
	current_score = 0
	is_running = true
	do_update_ui()
	
func end_game():
	cleanup()
	restart_delay_time = 0.0
	if current_score > high_score:
		high_score = current_score
	is_running = false
	do_update_ui()
	
func create_player():
	var new_player = plane.instance()
	new_player.position = Vector2(7, 32)
	get_tree().root.add_child(new_player)

func cleanup():
	get_tree().call_group("entities", "queue_free")
	get_tree().call_group("main", "reset_spotlight")

func add_score():
	current_score += 1
	do_update_ui()

func do_update_ui():
	get_tree().call_group("main", "update_ui")
