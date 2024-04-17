extends TextureProgressBar

# 角色的能量属性
var player

# 能量消耗速率（每次翻滚消耗的能量）
var rollEnergyCost = 20

# 能量自动回复速率（每秒回复的能量值）
var energyRegenRate = 10
var energyRegenTimer = 0
var energyRegenInterval = 1  # 每秒钟回复一次

func _ready():
	player = get_node("/root/MainScene/Player")
	player.healthChanged.connect(update)
	update()

func _process(delta):
	# 更新能量条
	update()
	
	# 检查角色是否正在翻滚
	if Input.is_action_pressed("Roll") and player.energy >= rollEnergyCost:
		# 消耗能量
		player.energy -= rollEnergyCost
		# 更新能量条
		update()
	# 如果角色没有按翻滚键或者能量不足，则每秒回复一定量的能量
	else:
		energyRegenTimer += delta
		if energyRegenTimer >= energyRegenInterval:
			energyRegenTimer = 0
			if player.energy < player.maxEnergy:
				player.energy = min(player.energy + energyRegenRate, player.maxEnergy)

func update():
	# 更新能量条
	value = player.energy * 100 / player.maxEnergy
