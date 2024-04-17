extends ProgressBar  # 继承自ProgressBar，用于展示一个进度条，常用于显示生命值等进度信息

func _ready():
	# 获取场景中玩家节点的引用
	var player = get_node("/root/MainScene/Player")
	# 将玩家的healthChanged信号连接到这个进度条的update方法
	# 这样每当玩家的生命值改变时，update方法会被自动调用
	player.healthChanged.connect(update)
	# 初始更新进度条以反映当前玩家的生命状态
	update()

func update():
	# 再次获取玩家节点的引用
	var player = get_node("/root/MainScene/Player")
	# 计算玩家当前的生命值占其最大生命值的百分比
	value = player.currentHealth * 100 / player.maxHealth
	# 更新ProgressBar的value属性，以视觉上反映玩家的当前生命百分比
	self.value = value
