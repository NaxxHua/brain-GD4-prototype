extends Marker2D

@onready var myLabel: Label = $DamageNumber

func _ready():
	print("Children of FloatingNumbers: ")
	for child in get_children():
		print(child.name)

func set_damage_value(damage_value: int) -> void:
	myLabel = $DamageNumber
	print(damage_value)
	if myLabel:
		myLabel.text = str(damage_value)
	else:
		push_error("Label node not found in FloatingNumbers scene.")
