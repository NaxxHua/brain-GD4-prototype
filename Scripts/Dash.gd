extends State  # 继承自State类，用于定义游戏对象的状态

var can_transition: bool = false  # 用于控制是否可以从当前状态转换到其他状态

# 进入状态时调用的方法
func enter():
	super.enter()  # 调用父类的enter方法
	animation_player.play("glowing")  # 播放名为"glowing"的动画
	await dash()  # 执行冲刺动作，并等待其完成
	can_transition = true  # 冲刺完成后，设置可以进行状态转换

# 定义冲刺动作，使用Tween来实现平滑的移动动画
func dash():
	var tween = create_tween()  # 创建一个新的Tween节点
	tween.tween_property(owner, "position", player.position, 0.8)  # 配置Tween来在0.8秒内将owner的位置移动到player的位置
	await tween.finished  # 等待Tween动画完成

# 进行状态转换的方法
func transition():
	if can_transition:  # 检查是否可以转换状态
		can_transition = false  # 将转换标志重置为false
		get_parent().change_state("Follow")  # 调用父节点的change_state方法，切换到"Follow"状态
