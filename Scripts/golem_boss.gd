extends CharacterBody2D

@onready var player = get_parent().find_child("Player")
@onready var sprite = $Sprite2D
@onready var progress_bar = $UI/ProgressBar

var direction : Vector2
var DEF = 0
var gravity = 2000

var health = 1000:
	set(value):
		health = value
		progress_bar.value = value
		if value <= 0:
			progress_bar.visible = false
			find_child("FiniteStateMachine").change_state("Death")
		elif value <= progress_bar.max_value / 2 and DEF == 0:
			DEF = 5
			find_child("FiniteStateMachine").change_state("ArmorBuff")

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

func take_damage(damage_amount: int):
	health -= damage_amount - DEF
	var popup_location = get_node("PopupLocation")
	if popup_location:
		popup_location.popup(damage_amount)
