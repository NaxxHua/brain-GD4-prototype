extends Node2D  # 继承自Node2D，提供2D游戏节点的功能

@onready var player = get_node("/root/DrtLab/Player")  # 获取玩家节点的引用
@onready var label = $Label  # 获取Label节点的引用，用于显示交互提示

const base_text = "按[F]以"  # 用于标签的基本文本，后接具体的动作名称

var active_areas = []  # 存储当前活跃的交互区域
var can_interact = true  # 控制玩家是否可以开始新的交互

# 注册一个新的交互区域
func register_area(area: InteractionArea):
	active_areas.push_back(area)  # 将区域添加到列表

# 注销一个交互区域
func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)  # 找到区域在列表中的索引
	if index != -1:
		active_areas.remove_at(index)  # 如果找到，从列表中移除

# 每帧调用处理交互逻辑
func _process(delta):
	if active_areas.size() > 0 and can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)  # 根据距离玩家的远近排序交互区域
		label.text = base_text + active_areas[0].action_name  # 设置标签文本显示最近的交互动作
		label.global_position = active_areas[0].global_position  # 设置标签位置
		label.global_position.y -= 36  # 调整标签的Y坐标以避免重叠
		label.global_position.x -= label.size.x / 2  # 中心对齐标签
		label.show()  # 显示标签
	else:
		label.hide()  # 没有可交互的区域时隐藏标签

# 自定义排序函数，比较两个区域与玩家的距离
func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = player.global_position.distance_to(area1.global_position)  # 计算区域1到玩家的距离
	var area2_to_player = player.global_position.distance_to(area2.global_position)  # 计算区域2到玩家的距离
	return area1_to_player < area2_to_player  # 返回比较结果

# 处理输入事件
func _input(event):
	if event.is_action_pressed("interact") and can_interact:  # 检测是否按下了交互键，并且可以交互
		if active_areas.size() > 0:
			can_interact = false  # 暂时禁止其他交互
			label.hide()  # 隐藏标签
			
			await active_areas[0].interact.call()  # 调用最近交互区域的交互方法
			
			can_interact = true  # 恢复交互功能
