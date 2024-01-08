extends Area2D

signal opening_door


func _on_area_entered(area):
	if area.name == "Sword":
		$anim.play("Activating")
		await $anim.animation_finished
		$anim.play("Activated")
		emit_signal("opening_door")
