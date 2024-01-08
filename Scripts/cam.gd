extends Camera2D

#@onready var player = get_node("../Player")
#var speed = 100
#var is_moving = false
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	position = player.global_position
#	var x = floor(position.x / 320) * 320
#	var y = floor(position.y / 180) * 180
#	global_position = Vector2(x, y)
#	is_moving = true
#
#	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
#	tween.tween_property(self, "position", Vector2(x,y), 0.14)
