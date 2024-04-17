extends CanvasLayer  # 继承自CanvasLayer，适合用来管理GUI元素

# 当节点首次进入场景树时调用
func _ready():
	pass  # 初始化完成时不需要执行任何操作

# 处理输入事件
func _input(event):
	if event.is_action_pressed("CharacterSheet"):  # 检查是否按下了打开/关闭角色信息面板的快捷键
		if not has_node("CharacterSheet"):  # 如果当前场景中不存在角色信息面板
			# 从项目的资源中加载角色信息面板场景
			var character_sheet = load("res://Scenes/UI/character_sheet.tscn").instantiate()
			add_child(character_sheet)  # 将加载的角色信息面板实例添加到当前CanvasLayer
		else:
			# 如果面板已存在，将其从场景树中移除
			get_node("CharacterSheet").queue_free()
