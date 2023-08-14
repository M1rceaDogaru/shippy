extends AnimatedSprite

func _ready():
	$Explode.play()

func _on_Explosion_animation_finished():
	queue_free()
