extends Node2D  # 继承自Node2D，通常用于2D场景的节点

@onready var player = get_node("../Player")  # 获取Player节点的引用
@onready var gui = get_node("../GUI")  # 获取GUI节点的引用
@onready var cam = get_node("../Player/Camera2D")  # 获取Camera2D节点的引用，它位于Player节点下

var map_key = 0  # 用于追踪地图键位被按下的次数

# 当节点首次进入场景树时调用
func _ready():
	visible = false  # 初始设置地图为不可见

# 每帧调用，处理地图的显示和隐藏逻辑
func _process(delta):
	if Input.is_action_just_pressed("ui_map"):  # 检测地图键是否刚被按下
		map_key += 1  # 增加地图键按下的计数
		if map_key == 1:  # 第一次按下地图键
			get_tree().paused = true  # 暂停游戏
			$PlayerHead.position = player.global_position  # 将地图上的玩家头像位置同步到玩家的全局位置
			visible = true  # 显示地图
			gui.visible = false  # 隐藏GUI
			cam.zoom = Vector2(1, 1)  # 将相机缩放设置为正常
			cam.offset = Vector2(-100, -140)  # 调整相机的偏移以适应地图视图
		if map_key >= 2:  # 如果地图键被按了两次或更多
			$PlayerHead.position = self.position  # 将玩家头像位置重置
			visible = false  # 隐藏地图
			map_key = 0  # 重置地图键按下计数
			get_tree().paused = false  # 恢复游戏
			gui.visible = true  # 显示GUI
			cam.zoom = Vector2(3, 3)  # 将相机缩放设置回游戏默认值
			cam.offset = Vector2(0, 0)  # 重置相机偏移
