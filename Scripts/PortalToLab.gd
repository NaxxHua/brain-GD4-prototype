extends Node2D

# 引用交互区域节点
@onready var interaction_area: InteractionArea = $InteractionArea

func _ready():
	# 将交互区域的interact属性设置为该节点上的"_on_interact"方法
	interaction_area.interact = Callable(self, "_on_interact")

# 当交互发生时触发的方法
func _on_interact():
	# 切换到实验室场景
	get_tree().change_scene_to_file("res://Scenes/drt_lab.tscn")
