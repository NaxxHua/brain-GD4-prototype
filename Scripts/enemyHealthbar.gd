extends TextureProgressBar  # 继承自TextureProgressBar，用于显示进度条

# 当节点准备完毕时调用的方法
func _ready():
	var enemy = get_node("/root/MainScene/Enemy")  # 获取敌人节点的引用
	enemy.healthChanged.connect(update)  # 连接敌人的healthChanged信号到本节点的update方法
	update()  # 初始调用update方法以设置初始生命条状态

# 更新生命条的显示状态和进度
func update():
	var enemy = get_node("/root/MainScene/Enemy")  # 再次获取敌人节点的引用
	value = enemy.health * 100 / enemy.maxHealth  # 计算敌人当前生命值占最大生命值的百分比
	if value >= 100:
		self.visible = false  # 如果生命值满了，则隐藏生命条
	else:
		self.visible = true  # 否则显示生命条

