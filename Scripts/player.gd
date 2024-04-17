extends CharacterBody2D

class_name Player

signal healthChanged

@export var bullet_node: PackedScene

enum PlayerStates {
	MOVE,
	HURT,
	SWORD,
	DEAD,
	ROLL
}
var currentState = PlayerStates.MOVE

var speed = 200.0
var gravity = 20
var jump = 400
var pressed = 2

var roll_speed = 400.0
var roll_duration = 0.5
var roll_timer = 0.0

# 属性系统
var level = 1
var stat_points = 100
var strength = 15
var dexterity = 1
var intelligence = 1
var stamina = 1

var dps = ceil(1 * 1.05 ** ((strength-3)*(dexterity-3)*(intelligence-3)) * (1 + 0.1))
@export var maxHealth = stamina * 20
@onready var currentHealth: int = maxHealth

@export var bullet_cooldown: float = 0.2 # 子弹的冷却时间，单位为秒
var last_shot_time: float = -bullet_cooldown # 上次射击时间

func _ready():
	randomize() # 初始化随机数生成器
	$Sword/CollisionShape2D.disabled = true

func LevelUp():
	level += 1
	stat_points += 5

func update_derived_stats():
	dps = ceil(1 * 1.05 ** ((strength-3)*(dexterity-3)*(intelligence-3)) * (1 + 0.1))  # 更新DPS的计算方式
	maxHealth = stamina * 10  # 更新最大生命值的计算方式

# 计算实际的伤害值
func calculate_damage() -> int:
	var variance = 5 # 你可以调整这个值以增大或减小随机波动的范围
	var random_factor = randf_range(-variance, variance) # 随机波动值
	return max(1, ceil(dps + int(random_factor))) # 确保伤害值至少为1

func _physics_process(delta):
#	Move(delta)
	
	match currentState:
		PlayerStates.MOVE:
			Move(delta)
		PlayerStates.SWORD:
			Sword()
		PlayerStates.DEAD:
			Dead()
		PlayerStates.ROLL:
			Roll(delta)
	
	velocity.y += 20
	move_and_slide()

func Roll(delta):
	if roll_timer > 0:
		roll_timer -= delta
		if $Sprite2D.flip_h:
			velocity.x = -roll_speed
		else:
			velocity.x = roll_speed
		$anim.play("Roll") # 确保有一个名为"Roll"的动画
	else:
		OnStateFinished() # 翻滚结束后回到MOVE状态

	if is_on_floor():
		velocity.y += gravity * delta # 确保角色贴地
		
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

func Jump():
	$anim.play("Jump")
	velocity.y -= jump
	
func Sword():
	$anim.play("Sword")
	
func Dead():
	$anim.play("Dead")
	await $anim.animation_finished
	if is_inside_tree():
		get_tree().reload_current_scene()
		currentHealth = maxHealth
		OnStateFinished()
	
func OnStateFinished():
	currentState = PlayerStates.MOVE

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

func take_damage(damage_amount: int):
	currentHealth -= damage_amount
	var popup_location = get_node("PopupLocation")
	if popup_location:
		popup_location.popup(damage_amount)

func shoot():
	var current_time = Time.get_ticks_msec() / 1000.0 # 获取当前时间（秒）
	if current_time - last_shot_time >= bullet_cooldown:
		var bullet = bullet_node.instantiate()
		
		bullet.position = global_position
		bullet.direction = Vector2.LEFT if $Sprite2D.flip_h else Vector2.RIGHT
		
		var damage_variance = randf_range(-5, 5)
		bullet.damage = max(1, dps + int(damage_variance))
		
		get_tree().current_scene.call_deferred("add_child", bullet)
		last_shot_time = current_time # 更新上次射击时间

func _input(event):
	if event.is_action("Shoot"):
		shoot()
	if event.is_action_pressed("Roll") and currentState == PlayerStates.MOVE:
		currentState = PlayerStates.ROLL
		roll_timer = roll_duration # 设置翻滚时间
