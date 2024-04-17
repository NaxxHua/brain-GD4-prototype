extends State  # 继承自State类，用于实现具体的状态逻辑

@export var bullet_node: PackedScene  # 从编辑器中导出，允许指定具体的子弹场景

var can_transition: bool = false  # 标记是否可以转换到下一个状态

func enter():
	super.enter()  # 调用父类的enter方法，确保任何基类逻辑被执行
	animation_player.play("ranged_attack")  # 播放远程攻击动画
	await animation_player.animation_finished  # 等待动画完成
	shoot()  # 动画完成后调用射击函数
	can_transition = true  # 设置状态转换标志为真，表示可以转换到下一个状态

func shoot():
	var bullet = bullet_node.instantiate()  # 实例化子弹场景
	bullet.position = owner.position  # 设置子弹的位置为当前拥有者（即Boss）的位置
	get_tree().current_scene.add_child(bullet)  # 将子弹节点添加到当前场景

func transition():
	if can_transition:  # 检查是否可以转换状态
		can_transition = false  # 重置状态转换标志
		get_parent().change_state("Dash")  # 调用父节点（状态机）的change_state方法，切换到Dash状态
