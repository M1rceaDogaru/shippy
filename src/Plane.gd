extends Area2D

export var speed = 60
var screen_size
onready var velocity = Vector2(0, speed)
onready var projectile = preload("res://Projectile/Projectile.tscn")
onready var explosion = preload("res://Explosion/Explosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not Game.is_running:
		return
		
	if Input.is_action_just_pressed("fire"):
		fire()
		velocity.y *= -1
	
	position += velocity * delta
	
	if position.y > screen_size.y:
		position.y = 0
	elif position.y < 0:
		position.y = screen_size.y

func fire():
	$Shoot.play()
	var new_projectile = projectile.instance()
	new_projectile.position = Vector2(position.x + 4, position.y)
	get_tree().root.add_child(new_projectile)

func _on_Plane_area_entered(area):
	if area.name == "Spotlight":
		return
		
	var new_explosion = explosion.instance()
	new_explosion.position = position
	get_tree().root.add_child(new_explosion)
	
	Game.end_game()
	queue_free()
