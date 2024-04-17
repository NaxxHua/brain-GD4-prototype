extends Area2D  # 继承自Area2D，用于检测2D碰撞

# 使用onready关键字获取节点，确保它们在节点树中已准备好
@onready var animated_sprite = $AnimatedSprite2D  # 子弹的动画
@onready var player = get_parent().find_child("Player") # 获取父节点中的Player节点

# 初始化加速度和速度向量
var acceleration: Vector2 = Vector2.ZERO  # 子弹的加速度
var velocity: Vector2 = Vector2.ZERO  # 子弹的速度

# 在物理处理函数中更新子弹的状态
func _physics_process(delta):
	# 计算从子弹到玩家的方向，并将其标准化，然后乘以加速度常数
	acceleration = (player.position - position).normalized() * 70
	
	# 更新速度
	velocity += acceleration * delta
	# 设置子弹的旋转方向以匹配速度方向
	rotation = velocity.angle()
	
	# 限制子弹的最大速度
	velocity = velocity.limit_length(150)
	
	# 根据速度更新子弹的位置
	position += velocity * delta

# 当子弹碰撞到其他物体时的处理
func _on_body_entered(body):
	# 如果碰撞的物体是Player类的实例或TileMap类的实例
	if body is Player or body is TileMap:
		queue_free()  # 销毁子弹节点
