extends CharacterBody2D  # 继承自CharacterBody2D，适用于需要物理行为的2D角色

class_name Enemy  # 为这个脚本定义一个全局类名Enemy

var moving_left = true  # 控制敌人移动方向的布尔变量
var speed = 15  # 敌人的移动速度
var gravity = 30  # 重力值
@export var dps = 1  # 敌人的每秒伤害，可以在编辑器中调整

signal healthChanged  # 用于广播生命值变化的信号

@export var maxHealth = 100  # 敌人的最大生命值，可以在编辑器中调整
var health = maxHealth  # 当前生命值初始化为最大值

func _ready():
	randomize()  # 初始化随机数生成器，确保随机性
	$anim.play("Idle")  # 开始时播放闲置动画

# 计算实际的伤害值，包括一个随机波动
func calculate_damage() -> int:
	var variance = 5  # 伤害波动范围
	var random_factor = randf_range(-variance, variance)  # 计算随机波动值
	return max(1, dps + int(random_factor))  # 返回计算后的伤害值，至少为1

# 物理处理函数，每一帧调用一次
func _physics_process(delta):
	Move()  # 调用移动函数
	floor_detect()  # 检测是否需要改变移动方向

# 处理敌人的移动
func Move():
	if moving_left:
		velocity.x = -speed  # 向左移动
	else:
		velocity.x = speed  # 向右移动
	move_and_slide()  # 应用重力并移动敌人

# 检测地面和墙壁，来改变移动方向
func floor_detect():
	if !$RayCastY.is_colliding() && is_on_floor():
		moving_left = !moving_left
		scale.x = -scale.x
		$Node2D.scale.x = - $Node2D.scale.x
	elif !$RayCastX.is_colliding() && is_on_wall():
		moving_left = !moving_left
		scale.x = -scale.x
		$Node2D.scale.x = - $Node2D.scale.x

# 显示受伤闪光效果
func flash():
	$Sprite2D.material.set_shader_parameter("flash_modifier", 1)
	await (get_tree().create_timer(0.3)).timeout
	$Sprite2D.material.set_shader_parameter("flash_modifier", 0)
	
# 当敌人被攻击区域触碰时调用
func _on_hitbox_area_entered(area):
	if area.name == "Sword":
		var player = get_node("/root/MainScene/Player")
		flash()  # 敌人闪光表示受伤
		take_damage(player.calculate_damage())  # 调用受伤函数
		healthChanged.emit()  # 发射生命值改变的信号

# 处理敌人受到的伤害
func take_damage(damage_amount: int):
	health -= damage_amount  # 减少生命值
	# 显示伤害数值
	var popup_location = get_node("PopupLocation")
	if popup_location:
		popup_location.popup(damage_amount)
	
	if health <= 0:
		velocity.x = 0  # 停止移动
		$anim.play("Dead")  # 播放死亡动画
		await $anim.animation_finished
		queue_free()  # 确保在动画播放完毕后销毁敌人
