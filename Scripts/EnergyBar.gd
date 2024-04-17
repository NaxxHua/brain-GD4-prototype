extends TextureProgressBar

func _ready():
	# 获取玩家节点
	var player = get_node("/root/MainScene/Player")
	# 连接玩家的能量变化信号到当前节点的更新函数
	player.energyChanged.connect(update)
	# 更新能量条
	update()

func update():
	# 获取玩家节点
	var player = get_node("/root/MainScene/Player")
	# 计算并设置能量条的值为当前能量占最大能量的百分比
	value = player.energy * 100 / player.maxEnergy
