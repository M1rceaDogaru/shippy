extends Area2D

export var speed = 65
export var direction = Vector2(1, 0)
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	add_to_group("entities")

func _physics_process(delta):
	if not Game.is_running:
		return
		
	position += direction * speed * delta
	
	if position.x < 0 or position.x > screen_size.x or position.y < 0 or position.y > screen_size.y:
		queue_free()

func _on_Projectile_area_entered(_area):
	queue_free()
