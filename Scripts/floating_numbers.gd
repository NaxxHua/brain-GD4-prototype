extends Marker2D  # 继承自Marker2D，通常用于在游戏中标记特定的2D位置

@onready var myLabel: Label = $DamageNumber  # 获取场景中的Label节点，用于显示伤害数值

# 当节点准备完毕时调用的方法
func _ready():
	print("Children of FloatingNumbers: ")
	for child in get_children():  # 遍历此节点的所有子节点
		print(child.name)  # 打印每个子节点的名称，帮助调试和验证子节点是否正确

# 设置伤害值并更新Label节点显示
func set_damage_value(damage_value: int) -> void:
	myLabel = $DamageNumber  # 确保myLabel指向场景中正确的Label节点
	print(damage_value)  # 打印伤害值，用于调试
	if myLabel:  # 检查Label节点是否存在
		myLabel.text = str(damage_value)  # 设置Label的文本为伤害值
	else:
		push_error("Label node not found in FloatingNumbers scene.")  # 如果未找到Label节点，则抛出错误
