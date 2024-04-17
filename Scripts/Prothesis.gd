extends Node2D

# 引用交互区域节点
@onready var interaction_area: InteractionArea = $InteractionArea
# 引用Sprite节点
@onready var sprite = $Sprite2D

func _ready():
	# 将交互区域的interact属性设置为该节点上的"_on_interact"方法
	interaction_area.interact = Callable(self, "_on_interact")

# 当交互发生时触发的方法
func _on_interact():
	# 启动对话系统并播放与假肢相关的对话剧情
	Dialogic.start("timeline1-1-1prosthesis")
