extends CharacterBody2D

@onready var player = get_parent().find_child("Player")
@onready var sprite = $Sprite2D

var direction : Vector2

func _ready():
	set_physics_process(false)

func _process(delta):
	if direction.x < 0 :
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func _physics_process(delta):
	direction = player.position - position
	velocity = direction.normalized() * 10
	move_and_collide(velocity * delta)
