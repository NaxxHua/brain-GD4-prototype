extends Area2D

var direction = Vector2.RIGHT  # 子弹的方向，默认向右
var speed = 300  # 子弹速度
var damage = 0  # 子弹伤害值

# Sprite节点的引用
@onready var sprite = $Sprite2D

func _ready():
	# 根据方向翻转Sprite
	update_sprite_flip()

func _physics_process(delta):
	position += direction * speed * delta  # 根据速度和方向移动子弹
	
# 更新Sprite的翻转
func update_sprite_flip():
	# 如果方向是向左，则翻转Sprite
	sprite.flip_h = direction.x < 0

# 当子弹与其他物体碰撞时触发
func _on_body_entered(body):
	print("子弹碰撞到：", body.name)
	if body.has_method("take_damage"):  # 检查碰撞的物体是否具有take_damage方法
		body.take_damage(damage)  # 对碰撞到的物体造成伤害
		queue_free()  # 销毁子弹节点

# 当子弹离开屏幕时触发
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()  # 销毁子弹节点
