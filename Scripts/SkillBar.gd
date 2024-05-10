extends HBoxContainer

var slots: Array
var skills: Array = [FireShot, WaterBall, Tornado, DarkBall, Ultimate]
var keys: Array = ["MOUSE_LEFT", "MOUSE_RIGHT", "Q", "E", "R"]

func _ready():
	slots = get_children()
	for i in get_child_count():
		slots[i].change_key = keys[i]
		slots[i].skill = skills[i].new(slots[i])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
