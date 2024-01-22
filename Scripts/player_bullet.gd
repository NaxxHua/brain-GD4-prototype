extends Area2D

var direction = Vector2.RIGHT
var speed = 300
var damage = 0

func _physics_process(delta):
	position += direction * speed * delta


func _on_body_entered(body):
	print("子弹碰撞到：", body.name)
	if body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()



func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
