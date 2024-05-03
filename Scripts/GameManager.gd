# GameManager.gd
extends Node

# 玩家基础数据
var player_health = 100
var max_health = 100
var player_energy = 100
var max_energy = 100
var player_stat_points = 10
var player_strength = 1
var player_dexterity = 1
var player_intelligence = 1
var player_stamina = 1

# 玩家属性增加点数
var strength_add = 0
var dexterity_add = 0
var intelligence_add = 0
var stamina_add = 0

# 信号定义
signal health_changed
signal energy_changed
signal stats_changed

# 初始化玩家的统计数据
func _ready():
	# 初始加载可以从存档中读取或者设定默认值
	player_health = max_health
	player_energy = max_energy
	emit_signal("health_changed")
	emit_signal("energy_changed")
	emit_signal("stats_changed")

# 修改生命值
func modify_health(amount):
	player_health += amount
	if player_health > max_health:
		player_health = max_health
	elif player_health < 0:
		player_health = 0
	emit_signal("health_changed")

# 修改能量
func modify_energy(amount):
	player_energy += amount
	if player_energy > max_energy:
		player_energy = max_energy
	elif player_energy < 0:
		player_energy = 0
	emit_signal("energy_changed")

# 更新统计数据
func update_stats():
	# 更新属性值
	emit_signal("stats_changed")

# 功能方法：如玩家等级提升
func level_up():
	player_stat_points += 5
	update_stats()

# 设置增加的属性点
func add_stat_points(stat, amount):
	if stat == "strength":
		strength_add += amount
	elif stat == "dexterity":
		dexterity_add += amount
	elif stat == "intelligence":
		intelligence_add += amount
	elif stat == "stamina":
		stamina_add += amount
	player_stat_points -= amount
	update_stats()

# 确认属性变化并计算新的衍生数据
func confirm_stats_changes():
	player_strength += strength_add
	player_dexterity += dexterity_add
	player_intelligence += intelligence_add
	player_stamina += stamina_add
	# 重置临时增加点
	strength_add = 0
	dexterity_add = 0
	intelligence_add = 0
	stamina_add = 0
	# 计算新的衍生数据，如最大生命值等
	max_health = player_stamina * 20
	modify_health(0)  # 触发生命值更新
	update_stats()
