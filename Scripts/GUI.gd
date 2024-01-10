extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	if event.is_action_pressed("CharacterSheet"):
		if not has_node("CharacterSheet"):
			var character_sheet = load("res://Scenes/UI/character_sheet.tscn").instantiate()
			add_child(character_sheet)
		else:
			get_node("CharacterSheet").queue_free()
