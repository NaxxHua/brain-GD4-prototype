extends ProgressBar

func _ready():
	var player = get_node("/root/MainScene/Player")
	player.healthChanged.connect(update)
	update()

func update():
	var player = get_node("/root/MainScene/Player")
	value = player.currentHealth * 100 / player.maxHealth
