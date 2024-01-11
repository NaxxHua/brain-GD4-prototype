extends TextureProgressBar

func _ready():
	var player = get_node("/root/MainScene/Player")
	player.healthChanged.connect(update)
	update()

func update():
	var player = get_node("/root/MainScene/Player")
	value = player.currentHealth * 100 / player.maxHealth
	update_health_label(player.currentHealth, player.maxHealth)

func update_health_label(health_value: int, max_health: int):
	var player = get_node("/root/MainScene/Player")
	var health_label = get_node("HealthLabel")
	health_label.text = str(player.currentHealth) + " / " + str(player.maxHealth)
