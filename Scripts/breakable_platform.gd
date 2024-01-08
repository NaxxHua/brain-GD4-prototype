extends StaticBody2D

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		$anim.play("Destroyed")
		await $anim.animation_finished
		$anim.play("Respawn")
