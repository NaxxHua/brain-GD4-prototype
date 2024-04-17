extends State  # 继承自State，用于定义具体的行为状态

# 使用onready关键字获取上级节点中的PlayerDetection子节点下的CollisionShape2D节点的引用
@onready var collision = $"../../PlayerDetection/CollisionShape2D"

# 使用owner.find_child获取拥有者节点下名为ProgressBar的子节点
@onready var progress_bar = owner.find_child("ProgressBar")

# player_enterted用于标记玩家是否进入检测区域
var player_enterted: bool = false:
	set(value):  # 当player_enterted值被设置时触发
		player_enterted = value
		collision.set_deferred("disabled", value)  # 延迟设置collision的disabled属性，避免立即影响物理处理
		progress_bar.set_deferred("visible", value)  # 延迟设置progress_bar的visible属性，使其在需要时显示或隐藏

# transition函数检查是否需要改变状态
func transition():
	if player_enterted:  # 如果玩家已经进入检测区域
		get_parent().change_state("Follow")  # 调用父节点的change_state方法，改变状态到Follow

# 当玩家的物体进入检测区域时调用
func _on_player_detection_body_entered(body):
	if body.name == "Player":  # 检测进入的是否为名为Player的节点
		player_enterted = true  # 设置player_enterted为true，触发set方法
