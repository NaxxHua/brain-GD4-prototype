extends Node2D
class_name State

# 引用调试文本节点
@onready var debug = owner.find_child("debug")
# 引用玩家节点
@onready var player = owner.get_parent().find_child("Player")
# 引用动画播放器节点
@onready var animation_player = owner.find_child("AnimationPlayer")

func _ready():
	# 初始时禁用物理过程
	set_physics_process(false)

# 进入状态时调用的方法
func enter():
	# 启用物理过程
	set_physics_process(true)

# 退出状态时调用的方法
func exit():
	# 禁用物理过程
	set_physics_process(false)

# 状态转换方法，需要在子类中实现
func transition():
	pass

# 物理过程处理方法
func _physics_process(delta):
	# 执行状态转换
	transition()
	# 更新调试文本显示状态名称
	debug.text = name
