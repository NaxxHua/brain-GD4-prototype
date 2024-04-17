extends Marker2D

@export var damage_node: PackedScene  # 伤害数字节点的预制资源

func _ready():
	randomize()  # 初始化随机数生成器

# 弹出伤害数字
func popup(damage_amount: int):
	var damage = damage_node.instantiate()  # 实例化伤害数字节点
	damage.set_damage_value(damage_amount)  # 设置伤害数字节点的伤害值
	damage.position = global_position  # 设置伤害数字节点的位置
	print(damage_amount)  # 打印伤害值，可选

	# 创建一个缓动动画
	var tween = get_tree().create_tween()
	tween.tween_property(damage, "position", global_position + _get_direction(), 0.75)  # 缓动伤害数字节点的位置

	get_tree().current_scene.add_child(damage)  # 将伤害数字节点添加到当前场景中

# 获取随机方向
func _get_direction() -> Vector2:
	return Vector2(randf_range(-1, 1), -randf()) * 16  # 返回一个随机方向向量，用于控制伤害数字的飘动方向和速度
