extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite = $Drt

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	
func _on_interact():
	if Dialogic.VAR.bossDead == true:
		Dialogic.start("timeline1-1-1part4")
	elif Dialogic.VAR.part2Done == true:
		Dialogic.start("timeline1-1-1part3")
	else:
		Dialogic.start("timeline1-1-1part2")
