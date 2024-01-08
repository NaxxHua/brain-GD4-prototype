extends CharacterBody2D

class_name Enemy

var moving_left = true
var speed = 15
var gravity = 30
@export var dps = 10

signal healthChanged

@export var maxHealth = 100
var health = maxHealth

func _ready():
	randomize() # 初始化随机数生成器
	$anim.play("Idle")

func calculate_damage() -> int:
	var variance = 5 # 你可以调整这个值以增大或减小随机波动的范围
	var random_factor = randf_range(-variance, variance) # 随机波动值
	return max(1, dps + int(random_factor)) # 确保伤害值至少为1

func _physics_process(delta):
	Move()
	floor_detect()

func Move():
	if moving_left:
		velocity.x = speed
	else:
		velocity.x = -speed
	move_and_slide()
	

func floor_detect():
	if !$RayCastY.is_colliding() && is_on_floor():
		moving_left = !moving_left
		scale.x = -scale.x
		$Node2D.scale.x = - $Node2D.scale.x
	elif !$RayCastX.is_colliding() && is_on_wall():
		moving_left = !moving_left
		scale.x = -scale.x
		$Node2D.scale.x = - $Node2D.scale.x

func flash():
	$Sprite2D.material.set_shader_parameter("flash_modifier", 1)
	await (get_tree().create_timer(0.3)).timeout
	$Sprite2D.material.set_shader_parameter("flash_modifier", 0)
	
func _on_hitbox_area_entered(area):
	if area.name == "Sword":
		var player = get_node("/root/MainScene/Player")
		flash()
		take_damage(player.calculate_damage())
		healthChanged.emit()

func take_damage(damage_amount: int):
	health -= damage_amount
	if health <= 0:
		velocity.x = 0
		$anim.play("Dead")
		await $anim.animation_finished
		queue_free()
	else:
		# If not dead, show the damage number through PopupLocation
		var popup_location = get_node("PopupLocation")
		if popup_location:
			popup_location.popup(damage_amount)
