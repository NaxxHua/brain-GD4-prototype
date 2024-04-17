extends CharacterBody2D  # 继承自CharacterBody2D，用于实现具有物理行为的2D角色

@onready var player = get_parent().find_child("Player")  # 获取父节点中名为"Player"的子节点
@onready var sprite = $Sprite2D  # 获取节点树中的Sprite2D节点
@onready var progress_bar = $UI/ProgressBar  # 获取UI节点下的ProgressBar

var direction : Vector2  # 用于存储方向向量
var DEF = 0  # 初始化防御力为0
var gravity = 2000  # 设置重力值

var health = 1000:  # 初始化生命值为1000，并定义setter方法
	set(value):
		health = value  # 设置生命值
		progress_bar.value = value  # 将生命值同步到进度条
		print("Boss 血量: ", health, ", 进度条值: ", progress_bar.value)
		if value <= 0:
			progress_bar.visible = false  # 生命值为0时隐藏进度条
			find_child("FiniteStateMachine").change_state("Death")  # 改变状态为Death
		elif value <= progress_bar.max_value / 2 and DEF == 0:
			DEF = 5  # 当生命值低于一半且防御力为0时增加防御力
			find_child("FiniteStateMachine").change_state("ArmorBuff")  # 改变状态为ArmorBuff

func _ready():
	set_physics_process(false)  # 默认不启用物理处理

func _process(delta):
	direction = player.position - position  # 计算与玩家的方向向量
	if direction.x < 0:
		sprite.flip_h = true  # 根据方向翻转精灵
	else:
		sprite.flip_h = false

func _physics_process(delta):
	direction = player.position - position  # 更新方向向量
	velocity = direction.normalized() * 10  # 标准化方向向量并设置速度
	velocity.y += gravity * delta  # 应用重力影响
	move_and_slide()  # 移动Boss

func take_damage(damage_amount: int):
	var actual_damage = max(damage_amount - DEF, 0)  # 计算减去防御值后的实际伤害
	health -= actual_damage  # 应用伤害到生命值
	var popup_location = get_node("PopupLocation")  # 获取显示伤害的位置节点
	if popup_location:
		popup_location.popup(damage_amount)  # 显示伤害值
