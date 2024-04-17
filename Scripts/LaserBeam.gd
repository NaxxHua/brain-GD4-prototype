extends State  # 继承自State类，用于定义Boss的行为状态

@onready var pivot = $"../../Pivot"  # 获取Pivot节点，用于调整Boss激光发射的方向
var can_transition: bool = false  # 控制是否可以从当前状态转换到另一个状态

# 当Boss进入此状态时调用
func enter():
	super.enter()  # 调用基类的enter方法，以执行任何必要的基类逻辑
	await play_animation("laser_cast")  # 先播放激光预备动画
	await play_animation("laser")  # 播放实际激光发射的动画
	can_transition = true  # 设置可以进行状态转换

# 用于播放指定动画并等待动画播放完成
func play_animation(anim):
	animation_player.play(anim)  # 播放指定的动画
	await animation_player.animation_finished  # 等待动画播放完成

# 设置激光发射的目标方向
func set_target():
	pivot.rotation = (owner.direction - pivot.position).angle()  # 计算并设置Pivot的旋转角度，以指向玩家

# 进行状态转换的函数
func transition():
	if can_transition:  # 检查是否可以转换状态
		can_transition = false  # 重置转换标志
		get_parent().change_state("Dash")  # 调用父节点（状态机）的change_state方法，切换到Dash状态
