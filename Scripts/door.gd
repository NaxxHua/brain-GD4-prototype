extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_switch_opening_door():
	$anim.play("Opening")
	await  $anim.animation_finished
	$anim.play("Opened")


func _on_switch_2_opening_door():
	$anim.play("Opening")
	await  $anim.animation_finished
	$anim.play("Opened")
