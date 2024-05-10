extends Area2D

var speed : float = 200
var direction: Vector2 = Vector2.RIGHT:
	set(value):
		direction = value
		if $AnimatedSprite2D.animation != "Tornado":
			rotation = direction.angle()

func _physics_process(delta):
	position += speed * direction * delta
	
func play(animation_name = "Fire"):
	$AnimatedSprite2D.play(animation_name)

func _on_screen_exited():
	queue_free()
