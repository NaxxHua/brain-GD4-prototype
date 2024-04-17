extends CharacterBody2D

class_name Player

signal healthChanged  # 生命值变化信号
signal energyChanged  # 能量值变化信号

@export var bullet_node: PackedScene  # 子弹场景

enum PlayerStates {
	MOVE,   # 移动状态
	HURT,   # 受伤状态
	SWORD,  # 攻击状态
	DEAD,   # 死亡状态
	ROLL    # 翻滚状态
}
var currentState = PlayerStates.MOVE  # 当前状态，默认为移动状态

var speed = 200.0                   # 移动速度
var gravity = 20                    # 重力
var jump = 400                      # 跳跃力度
var pressed = 2                     # 跳跃按键连按计数

var roll_speed = 400.0              # 翻滚速度
var roll_duration = 0.5             # 翻滚持续时间
var roll_timer = 0.0                # 翻滚计时器

# 属性系统
var level = 1                       # 等级
var stat_points = 100               # 属性点
var strength = 15                   # 力量
var dexterity = 1                   # 敏捷
var intelligence = 1                # 智力
var stamina = 1                     # 耐力

var energy = 100                    # 当前能量值
var maxEnergy = 100                 # 最大能量值
var energyRegenRate = 10.0         # 能量回复速率

var dps = ceil(1 * 1.05 ** ((strength-3)*(dexterity-3)*(intelligence-3)) * (1 + 0.1))  # 每秒伤害
@export var maxHealth = stamina * 20  # 最大生命值，默认为耐力 * 20
@onready var currentHealth: int = maxHealth  # 当前生命值，默认为最大生命值

@export var bullet_cooldown: float = 0.2  # 子弹冷却时间，单位为秒
var last_shot_time: float = -bullet_cooldown  # 上次射击时间，默认为负的冷却时间

func _ready():
	randomize()  # 初始化随机数生成器
	$Sword/CollisionShape2D.disabled = true  # 禁用武器的碰撞形状

func LevelUp():
	level += 1
	stat_points += 5

func update_derived_stats():
	# 更新派生属性，如每秒伤害和最大生命值
	dps = ceil(1 * 1.05 ** ((strength-3)*(dexterity-3)*(intelligence-3)) * (1 + 0.1))
	maxHealth = stamina * 10

# 计算实际的伤害值
func calculate_damage() -> int:
	var variance = 5  # 伤害波动范围
	var random_factor = randf_range(-variance, variance)  # 随机波动值
	return max(1, ceil(dps + int(random_factor)))  # 最终伤害值

func _physics_process(delta):
	regenerate_energy(delta)  # 每帧自动回复能量
	match currentState:
		PlayerStates.MOVE:
			Move(delta)
		PlayerStates.SWORD:
			Sword()
		PlayerStates.DEAD:
			Dead()
		PlayerStates.ROLL:
			Roll(delta)
	
	velocity.y += 20  # 竖直方向速度增加
	move_and_slide()  # 移动并滑动

# 自动回复能量
func regenerate_energy(delta: float):
	if currentState == PlayerStates.MOVE and energy < maxEnergy:
		energy = min(energy + energyRegenRate * delta, maxEnergy)
		emit_signal("energyChanged")  # 发射能量变化信号

# 翻滚动作
func Roll(delta):
	if roll_timer > 0:
		roll_timer -= delta
		if $Sprite2D.flip_h:
			velocity.x = -roll_speed
		else:
			velocity.x = roll_speed
		$anim.play("Roll")  # 播放翻滚动画
	else:
		OnStateFinished()  # 翻滚结束，返回移动状态

	if is_on_floor():
		velocity.y += gravity * delta  # 保持在地面上运动
		
# 移动动作
func Move(delta):
	var movement = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if movement != 0:
		if movement > 0.0:
			velocity.x += speed * delta
			velocity.x = clamp(speed, 100, speed)
			$Sprite2D.flip_h = false
			$anim.play("Walk")
			$Sword/CollisionShape2D.position = Vector2(24,0)
		
		if movement < 0.0:
			velocity.x -= speed * delta
			velocity.x = clamp(speed, -100, -speed)
			$Sprite2D.flip_h = true
			$anim.play("Walk")
			$Sword/CollisionShape2D.position = Vector2(-24,0)
	
	if movement == 0.0:
		velocity.x = 0.0
		$anim.play("Idle")
	
	if Input.is_action_just_pressed("ui_jump"):
		pressed -= 1
	
	if is_on_floor() && Input.is_action_just_pressed("ui_jump"):
		Jump()
		
	if !is_on_floor() && Input.is_action_just_pressed("ui_jump") && pressed >= 1:
		Jump()
	
	if pressed <= 0:
		velocity.y = velocity.y
		
	if is_on_floor():
		pressed = 2
		
	if !is_on_floor():
		$anim.play("Jump")
	
	if !is_on_floor() && velocity.y > 10:
		$anim.play("Fall")
	
	if Input.is_action_just_pressed("ui_sword"):
		currentState = PlayerStates.SWORD
		velocity.x = movement

# 跳跃动作
func Jump():
	$anim.play("Jump")
	velocity.y -= jump
	
# 攻击动作
func Sword():
	$anim.play("Sword")
	
# 死亡动作
func Dead():
	$anim.play("Dead")
	await $anim.animation_finished
	if is_inside_tree():
		get_tree().reload_current_scene()
		currentHealth = maxHealth
		OnStateFinished()
	
# 状态结束处理
func OnStateFinished():
	currentState = PlayerStates.MOVE

# 闪烁效果
func flash():
	$Sprite2D.material.set_shader_parameter("flash_modifier", 1)
	await (get_tree().create_timer(0.3)).timeout
	$Sprite2D.material.set_shader_parameter("flash_modifier", 0)

func _on_hitbox_body_entered(body):
	if body.name == "Enemy":
		var enemy = get_node("/root/MainScene/Enemy")
		flash()
		take_damage(enemy.calculate_damage())
		healthChanged.emit()
		
	if currentHealth <= 0:
		currentState = PlayerStates.DEAD

func _on_hitbox_area_entered(area):
	if area.name == "Sword":
		var player = get_node("/root/MainScene/Player")
		flash()
		take_damage(player.calculate_damage())
		healthChanged.emit()

# 承受伤害
func take_damage(damage_amount: int):
	currentHealth -= damage_amount
	var popup_location = get_node("PopupLocation")
	if popup_location:
		popup_location.popup(damage_amount)

# 射击
func shoot():
	var current_time = Time.get_ticks_msec() / 1000.0  # 获取当前时间（秒）
	if current_time - last_shot_time >= bullet_cooldown:
		var bullet = bullet_node.instantiate()
		
		bullet.position = global_position
		bullet.direction = Vector2.LEFT if $Sprite2D.flip_h else Vector2.RIGHT
		
		var damage_variance = randf_range(-5, 5)
		bullet.damage = max(1, dps + int(damage_variance))
		get_tree().current_scene.call_deferred("add_child", bullet)
		last_shot_time = current_time  # 更新上次射击时间

func _input(event):
	if event.is_action("Shoot"):
		shoot()
	if event.is_action_pressed("Roll") and currentState == PlayerStates.MOVE and energy >= 20:
		if consume_energy(20):
			currentState = PlayerStates.ROLL
			roll_timer = roll_duration  # 设置翻滚时间

# 消耗能量
func consume_energy(amount: int) -> bool:
	if energy >= amount:
		energy -= amount
		energyChanged.emit()  # 发射能量变化信号
		return true
	else:
		return false
