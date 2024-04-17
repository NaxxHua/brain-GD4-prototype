extends Node2D  # 继承自Node2D，表示这是一个2D节点

# 使用onready关键字来获取场景树中的节点，确保它们在节点已经准备好时才访问
@onready var interaction_area: InteractionArea = $InteractionArea  # 用于交互检测的自定义区域
@onready var sprite = $Sprite2D  # 咖啡机的精灵图像

# 节点准备完毕时调用的方法
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")  # 将互动区域的互动行为绑定到此函数

# 当与咖啡机互动时调用的方法
func _on_interact():
	Dialogic.start("timeline1-1-1coffeeMachine")  # 启动Dialogic插件中的特定时间线，开始对话或事件
