extends Area2D

export var despawn_offset = 16
export var direction = Vector2(-1, 0)
export var speed = 0

var screen_size

onready var explosion = preload("res://Explosion/Explosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	speed = Game.current_enemy_speed
	add_to_group("entities")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not Game.is_running:
		return
		
	position += direction * speed * delta
	
	# could optimize this by storing offset results but meh
	if position.x < -despawn_offset or position.x > screen_size.x + despawn_offset or position.y < -despawn_offset or position.y > screen_size.y + despawn_offset:
		queue_free()

func _on_Enemy_area_entered(_area):
	Game.add_score()
	
	var new_explosion = explosion.instance()
	new_explosion.position = position
	get_tree().root.add_child(new_explosion)
	queue_free()
