extends TextureProgressBar

# 当节点准备好时调用的方法
func _ready():
	# 获取玩家节点
	var player = get_node("/root/MainScene/Player")
	# 将玩家的healthChanged信号连接到update方法
	player.healthChanged.connect(update)
	# 更新生命状态条
	update()

# 更新生命状态条的方法
func update():
	# 获取玩家节点
	var player = get_node("/root/MainScene/Player")
	# 计算生命状态条的值
	value = player.currentHealth * 100 / player.maxHealth
	# 更新生命状态条的显示
	update_health_label(player.currentHealth, player.maxHealth)

# 更新生命值标签的方法
func update_health_label(health_value: int, max_health: int):
	# 获取玩家节点
	var player = get_node("/root/MainScene/Player")
	# 获取生命值标签节点
	var health_label = get_node("HealthLabel")
	# 设置生命值标签的文本为当前生命值和最大生命值
	health_label.text = str(player.currentHealth) + " / " + str(player.maxHealth)
