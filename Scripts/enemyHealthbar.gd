extends TextureProgressBar

func _ready():
	var enemy = get_node("/root/MainScene/Enemy")
	enemy.healthChanged.connect(update)
	update()

func update():
	var enemy = get_node("/root/MainScene/Enemy")
	value = enemy.health * 100 / enemy.maxHealth
	if value >= 100:
		self.visible = false
	else:
		self.visible = true
