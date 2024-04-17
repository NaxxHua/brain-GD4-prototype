extends Node2D  # 继承自Node2D，表示这是一个2D节点

# 使用onready关键字来获取场景树中的节点
@onready var interaction_area: InteractionArea = $InteractionArea  # 预先定义的交互区域
@onready var sprite = $Drt  # NPC的精灵

# 节点准备完毕时调用的方法
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")  # 设置交互区域的交互回调为本地_on_interact函数

# 当与NPC交互时调用的方法
func _on_interact():
	if Dialogic.VAR.bossDead == true:  # 检查Boss是否已被击败
		Dialogic.start("timeline1-1-1part4")  # 如果是，开始第四部分的对话
	elif Dialogic.VAR.part2Done == true:  # 检查第二部分是否完成
		Dialogic.start("timeline1-1-1part3")  # 如果是，开始第三部分的对话
	else:
		Dialogic.start("timeline1-1-1part2")  # 否则，开始第二部分的对话
