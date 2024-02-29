extends Node2D

func _ready():
	if Dialogic.VAR.part1Done != true:
		Dialogic.start("timeline1-1-1part1")
