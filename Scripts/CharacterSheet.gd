extends Control  # 继承自Control，是UI界面的一部分

# 使用onready获取Player节点和属性点标签的引用
@onready var player = get_node("../../Player")
@onready var node_stat_points = get_node("HBoxContainer/VBoxContainer/Stats/MainStats/StatPoints/Label")
var path_main_stats = "HBoxContainer/VBoxContainer/Stats/MainStats/"

# 可用的属性点数和对每个属性的加成值
var available_points
var str_add = 0
var dex_add = 0
var int_add = 0
var sta_add = 0

# 一个静态函数，用于将参数绑定到Callable对象
static func bindv(c: Callable, args: Array[Variant]):
	var res := c
	for idx in range(args.size(), 0, -1):
		res = res.bind(args[idx-1])
	return res

# 节点准备完毕时调用的方法
func _ready():
	LoadStats()
	available_points = player.stat_points
	node_stat_points.set_text(str(available_points) + " Points")
	if available_points == 0:
		pass
	else:
		for button in get_tree().get_nodes_in_group("PlusButtons"):
			button.disabled = false
	# 连接加号和减号按钮的按压信号到增减属性值的函数
	for button in get_tree().get_nodes_in_group("PlusButtons"):
		button.pressed.connect(bindv(Callable(self, "IncreaseStat"), [button.get_node("../..").get_name()]))
	for button in get_tree().get_nodes_in_group("MinusButtons"):
		button.pressed.connect(bindv(Callable(self, "DecreaseStat"), [button.get_node("../..").get_name()]))

# 从Player节点载入属性值并更新UI显示
func LoadStats():
	get_node(path_main_stats + "Str/StatBG/Stats/Value").set_text(str(player.strength))
	get_node(path_main_stats + "Dex/StatBG/Stats/Value").set_text(str(player.dexterity))
	get_node(path_main_stats + "Int/StatBG/Stats/Value").set_text(str(player.intelligence))
	get_node(path_main_stats + "Sta/StatBG/Stats/Value").set_text(str(player.stamina))
	get_node("HBoxContainer/VBoxContainer/Stats/DerivedStats/VBoxContainer/Damage/Value").set_text(str(player.dps))
	get_node("HBoxContainer/VBoxContainer/Stats/DerivedStats/VBoxContainer/HP/Value").set_text(str(player.maxHealth))

# 增加属性值的方法
func IncreaseStat(stat):
	set(stat.to_lower() + "_add", get(stat.to_lower() + "_add") + 1)
	get_node(path_main_stats + stat + "/StatBG/Stats/Change").set_text("+" + str(get(stat.to_lower() + "_add")) + " ")
	get_node(path_main_stats + stat + "/StatBG/Min").disabled = false
	available_points -= 1
	node_stat_points.set_text(str(available_points) + " Points")
	if available_points == 0:
		for button in get_tree().get_nodes_in_group("PlusButtons"):
			button.disabled = true

# 减少属性值的方法
func DecreaseStat(stat):
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

# 确认按钮被按下时调用的方法
func _on_confirm_pressed():
	if str_add + dex_add + int_add + sta_add == 0:
		print("Nothing to confirm, add your pop-up here if desired")
	else:
		player.stat_points = available_points
		player.strength += str_add
		player.dexterity += dex_add
		player.intelligence += int_add
		player.stamina += sta_add
		
		# 更新玩家的衍生属性
		player.update_derived_stats()
		# 更新UI以反映新的属性值
		update_ui_with_new_stats()
		
		# 更新血量条和血量文本
		var health_bar = get_node("../../GUI/HealthBar")
		health_bar.update()  # 更新血量条
		health_bar.update_health_label(player.currentHealth, player.maxHealth)  # 更新血量文本
		
		# 重置加到每个属性的点数
		str_add = 0
		dex_add = 0
		int_add = 0
		sta_add = 0
		LoadStats()
		for button in get_tree().get_nodes_in_group("MinusButtons"):
			button.disabled = true
		for label in get_tree().get_nodes_in_group("ChangeLabels"):
			label.set_text("")

# 使用新的属性值更新UI显示
func update_ui_with_new_stats():
	get_node("HBoxContainer/VBoxContainer/Stats/DerivedStats/VBoxContainer/Damage/Value").set_text(str(player.dps))
	get_node("HBoxContainer/VBoxContainer/Stats/DerivedStats/VBoxContainer/HP/Value").set_text(str(player.maxHealth))
