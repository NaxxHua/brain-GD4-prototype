extends Control

@onready var node_stat_points = get_node("HBoxContainer/VBoxContainer/Stats/MainStats/StatPoints/Label")
var path_main_stats = "HBoxContainer/VBoxContainer/Stats/MainStats"

var available_points = 5
var str_add = 0
var dex_add = 0
var int_add = 0
var sta_add = 0

static func bindv(c: Callable, args: Array[Variant]):
	var res := c
	for idx in range(args.size(), 0, -1):
		res = res.bind(args[idx-1])
	return res

func _ready():
	node_stat_points.set_text(str(available_points) + "Points")
	if available_points == 0:
		pass
	else:
		for button in get_tree().get_nodes_in_group("PlusButtons"):
			button.disabled = false
	for button in get_tree().get_nodes_in_group("PlusButtons"):
		button.pressed.connect(bindv(Callable(self, "IncreaseStat"), [button.get_node("../..").get_name()]))
	for button in get_tree().get_nodes_in_group("MinButtons"):
		button.pressed.connect(bindv(Callable(self, "DecreaseStat"), [button.get_parent().get_parent().name]))

func IncreaseStat(stat):
	print(stat + "Plus")
	
func DecreaseStat(stat):
	print(stat + "Minus")
