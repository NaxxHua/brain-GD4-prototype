extends State

@onready var collision = $"../../PlayerDetection/CollisionShape2D"

@onready var progress_bar = owner.find_child("ProgressBar")

var player_enterted: bool = false:
	set(value):
		player_enterted = value
		collision.set_deferred("disabled", value)
		progress_bar.set_deferred("visible", value)

func transition():
	if player_enterted:
		get_parent().change_state("Follow")


func _on_player_detection_body_entered(body):
	if body.name == "Player":
		player_enterted = true
