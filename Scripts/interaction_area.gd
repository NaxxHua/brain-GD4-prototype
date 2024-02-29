extends Area2D
class_name InteractionArea

@export var action_name: String = "interact"

var interact: Callable = func():
	pass


func _on_body_entered(body):
	InteractablesManager.register_area(self)


func _on_body_exited(body):
	InteractablesManager.unregister_area(self)
