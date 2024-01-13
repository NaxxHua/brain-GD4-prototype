extends CharacterBody2D

@onready var player = get_parent().find_child("Player")
@onready var sprite = $Sprite2D

var direction : Vector2

var gravity = 2000

func _ready():
	set_physics_process(false)

func _process(delta):
	direction = player.position - position
	if direction.x < 0 :
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func _physics_process(delta):
	direction = player.position - position
	velocity = direction.normalized() * 10
	velocity.y += gravity * delta
	move_and_slide()
	
