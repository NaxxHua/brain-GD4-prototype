extends Area2D  # 继承自Area2D，用于检测2D碰撞和区域重叠
class_name InteractionArea  # 为这个脚本定义一个全局可识别的类名

@export var action_name: String = "interact"  # 导出一个变量到编辑器，允许设置不同的交互动作名称

# 定义一个可调用的变量，用于执行具体的交互逻辑
var interact: Callable = func():
	pass  # 默认情况下不执行任何操作

# 当一个物体进入此区域时触发
func _on_body_entered(body):
	if body.is_in_group("player_group"):  # 检查进入区域的物体是否属于“player_group”组
		InteractablesManager.register_area(self)  # 如果是，通过InteractablesManager注册这个交互区

# 当一个物体离开此区域时触发
func _on_body_exited(body):
	InteractablesManager.unregister_area(self)  # 通过InteractablesManager注销这个交互区
