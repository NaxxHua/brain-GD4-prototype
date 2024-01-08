extends Area2D


func _on_body_entered(body):
	if body.name == "Player":
		Globals.playerCoin += 1
		$anim.play("Picked")
		await $anim.animation_finished
		queue_free()
