extends Control

@onready var player = get_node("../../Player")
@onready var node_stat_points = get_node("HBoxContainer/VBoxContainer/Stats/MainStats/StatPoints/Label")
var path_main_stats = "HBoxContainer/VBoxContainer/Stats/MainStats/"

var available_points
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
	LoadStats()
	available_points = player.stat_points
	node_stat_points.set_text(str(available_points) + " Points")
	if available_points == 0:
		pass
	else:
		for button in get_tree().get_nodes_in_group("PlusButtons"):
			button.disabled = false
	for button in get_tree().get_nodes_in_group("PlusButtons"):
		button.pressed.connect(bindv(Callable(self, "IncreaseStat"), [button.get_node("../..").get_name()]))
	for button in get_tree().get_nodes_in_group("MinusButtons"):
		button.pressed.connect(bindv(Callable(self, "DecreaseStat"), [button.get_node("../..").get_name()]))

func LoadStats():
	get_node(path_main_stats + "Str/StatBG/Stats/Value").set_text(str(player.strength))
	get_node(path_main_stats + "Dex/StatBG/Stats/Value").set_text(str(player.dexterity))
	get_node(path_main_stats + "Int/StatBG/Stats/Value").set_text(str(player.intelligence))
	get_node(path_main_stats + "Sta/StatBG/Stats/Value").set_text(str(player.stamina))

func IncreaseStat(stat):
	# Increase the stat_add (code)
	set(stat.to_lower() + "_add", get(stat.to_lower() + "_add") + 1)
	# Update the change label (visual feedback)
	get_node(path_main_stats + stat + "/StatBG/Stats/Change").set_text("+" + str(get(stat.to_lower() + "_add")) + " ")
	# Unlock the minus button
	get_node(path_main_stats + stat + "/StatBG/Min").disabled = false
	# Reduce the available stat points (code)
	available_points -= 1
	# Update the available stat points label (visual feedback)
	node_stat_points.set_text(str(available_points) + " Points")
	# If no available point, lock all plus buttons
	if available_points == 0:
		for button in get_tree().get_nodes_in_group("PlusButtons"):
			button.disabled = true
	
func DecreaseStat(stat):
	# Decrease the stat_add (code)
	set(stat.to_lower() + "_add", get(stat.to_lower() + "_add") - 1)
	if get(stat.to_lower() + "_add") == 0:
		get_node(path_main_stats + stat + "/StatBG/Min").disabled = true
		get_node(path_main_stats + stat + "/StatBG/Stats/Change").set_text("")
	else:
		get_node(path_main_stats + stat + "/StatBG/Stats/Change").set_text("+" + str(get(stat.to_lower() + "_add")) + " ")
	available_points += 1
	node_stat_points.set_text(str(available_points) + " Points")
	for button in get_tree().get_nodes_in_group("PlusButtons"):
		button.disabled = false

func _on_confirm_pressed():
	if str_add + dex_add + int_add + sta_add == 0:
		print("Nothing to confirm, add your pop-up here if desired")
	else:
		player.stat_points = available_points
		player.strength += str_add
		player.dexterity += dex_add
		player.intelligence += int_add
		player.stamina += sta_add
		str_add = 0
		dex_add = 0
		int_add = 0
		sta_add = 0
		LoadStats()
		for button in get_tree().get_nodes_in_group("MinusButtons"):
			button.disabled = true
		for label in get_tree().get_nodes_in_group("ChangeLabels"):
			label.set_text("")
