extends State  # 继承自State，一个用于定义游戏中不同行为状态的基类

# 当进入此状态时调用
func enter():
	super.enter()  # 调用父类的enter方法，确保所有基类逻辑被执行
	owner.set_physics_process(true)  # 激活物理处理，允许状态更新物理属性
	animation_player.play("idle")  # 播放idle（闲置）动画

# 当退出此状态时调用
func exit():
	super.exit()  # 调用父类的exit方法，确保所有基类逻辑被执行
	owner.set_physics_process(false)  # 停止物理处理，不再更新物理属性

# 用于决定是否需要从当前状态转换到另一个状态
func transition():
	var distance = owner.direction.length()  # 计算与目标之间的距离

	# 根据与玩家的距离决定下一个状态
	if distance < 30:
		get_parent().change_state("MeleeAttack")  # 如果玩家在近战范围内，则切换到近战攻击状态
	elif distance > 130:
		var chance = randi() % 2  # 生成一个随机数，用来随机选择远程攻击类型
		match chance:
			0:
				get_parent().change_state("HomingMissile")  # 选择发射追踪导弹
			1:
				get_parent().change_state("LaserBeam")  # 选择发射激光束
