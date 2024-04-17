extends State  # 继承自State，这是用于定义游戏对象状态的基类

# 进入此状态时调用的方法
func enter():
	super.enter()  # 调用父类的enter方法以确保基类的初始化逻辑被执行
	animation_player.play("death")  # 播放名为"death"的动画
	await animation_player.animation_finished  # 等待"death"动画播放完成
	Dialogic.VAR.bossDead = true  # 设置Dialogic插件中的变量，标记Boss已死亡
	animation_player.play("boss_slained")  # 播放名为"boss_slained"的动画，表示Boss被彻底击败
