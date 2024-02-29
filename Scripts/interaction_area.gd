extends Area2D
class_name InteractionArea

@export var action_name: String = "interact"

var interact: Callable = func():
	pass


func _on_body_entered(body):
	if body.is_in_group("player_group"):
		InteractablesManager.register_area(self)


func _on_body_exited(body):
	InteractablesManager.unregister_area(self)
