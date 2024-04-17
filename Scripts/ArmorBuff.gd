extends State  # 继承自State类

var can_transition: bool = false  # 定义一个变量来标记是否可以转换状态

func enter():
	super.enter()  # 调用基类的enter方法
	animation_player.play("armor_buff")  # 播放给boss加护甲的动画
	await animation_player.animation_finished  # 等待动画播放完成
	can_transition = true  # 设置状态可以转换

func transition():
	if can_transition:  # 如果可以转换状态
		can_transition = false  # 重置状态转换标记
		get_parent().change_state("Follow")  # 改变父节点的状态到"Follow"
