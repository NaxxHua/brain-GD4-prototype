extends State  # 继承自State类

func enter():  # 进入状态时执行的函数
	super.enter()  # 调用父类的enter函数
	animation_player.play("melee_attack")  # 播放近战攻击动画

func transition():  # 状态转换函数
	if owner.direction.length() > 30:  # 如果主角到boss的距离超过30个单位
		get_parent().change_state("Follow")  # 切换到Follow状态
