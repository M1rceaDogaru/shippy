extends Node2D

export var spawn_offset = 16
export var background_speed = 16
export var background_offset = -64

onready var enemy = preload("res://Enemy/Enemy.tscn")

var time_since_last_spawn = 0.0
var time_since_last_spotlight = 0.0
var spotlight_direction = Vector2(0, 0)

var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	update_ui()
	
	if not Game.is_running:
		return
		
	scroll_background(delta)
	move_spotlight(delta)
		
	time_since_last_spawn += delta
	if time_since_last_spawn > Game.current_spawn_interval:
		spawn_enemy()
		time_since_last_spawn = 0.0
	
func spawn_enemy():
	var new_enemy = enemy.instance()
	new_enemy.position = Vector2(screen_size.x + spawn_offset, rand_range(0, screen_size.y))
	get_tree().root.add_child(new_enemy)

func move_spotlight(delta):
	time_since_last_spotlight -= delta
	if time_since_last_spotlight < 0:
		reset_spotlight()
	
	var new_position = $Spotlight.position + spotlight_direction * Game.spotlight_speed * delta
	if new_position.y < 0 or new_position.y > screen_size.y:
		spotlight_direction = Vector2(spotlight_direction.x, -spotlight_direction.y)
	$Spotlight.position = new_position

func reset_spotlight():
	spotlight_direction = Vector2(rand_range(-1, -0.5), rand_range(-1, 1))
	$Spotlight.position = Vector2(screen_size.x + spawn_offset, rand_range(0, screen_size.y))
	time_since_last_spotlight = rand_range(Game.min_spotlight_interval, Game.max_spotlight_interval)
	
func scroll_background(delta):
	move_and_check($Background1, delta)
	move_and_check($Background2, delta)
	
func move_and_check(background:Node2D, delta):
	var new_position = background.position.x - background_speed * delta
	if background.position.x < background_offset:
		new_position = screen_size.x
	background.position = Vector2(new_position, background.position.y)
	
func spawn_wave():
	spawn_wave_enemy(15)
	spawn_wave_enemy(36)
	spawn_wave_enemy(56)
	
func spawn_wave_enemy(vertical_position):
	var new_enemy = enemy.instance()
	new_enemy.position = Vector2(screen_size.x + spawn_offset, vertical_position)
	get_tree().root.add_child(new_enemy)
	new_enemy.speed = Game.max_enemy_speed

func update_ui():
	$MainMenu.visible = not Game.is_running
	
	$Score.text = str(Game.current_score)
	if not Game.is_running:
		$MainMenu/Best.text = "BEST:" + str(Game.high_score)
