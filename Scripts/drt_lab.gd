extends Node2D  # 继承自Node2D，表示这是一个2D节点

# 节点准备完毕时调用的方法
func _ready():
	if not Dialogic.VAR.part1Done:  # 检查part1Done变量是否不为true
		Dialogic.start("timeline1-1-1part1")  # 如果不为true，则启动第一部分的对话
