extends Area2D
 
@export var speed: float = 1.0
@export var deviation_distance : float = 120
@export var deviation_angle : float = 60
 
var p0: Vector2
var p1: Vector2 
var p2: Vector2
 
var t: float = 0.0
 
var can_return : bool = true
var returning : bool = false
 
var type : String = "Projectile"
 
var enemy = null
var ignore_body = null
 
func _ready():
	set_physics_process(false)
	
	collision_layer = 1
	collision_mask &= ~(1 << 1)
	
	print("Projectile ready: ", type, " can_return: ", can_return)
	#set_destination(Vector2(192, 128))
 
 
func set_destination(destination):
	p0 = global_position
	p2 = destination
 
	var tilted_unit_vector = (p2-p0).normalized().rotated(deg_to_rad(-deviation_angle))
	p1 = p0 + deviation_distance * tilted_unit_vector	
 
 
	call_deferred("set_physics_process", true)
 
 
 
func set_deviation(distance, angle):
	deviation_distance = distance
	deviation_angle = angle
	print("Deviation set: distance = ", distance, " angle = ", angle)
 
func set_can_return(value):
	can_return = value
	print("Can return set to: ", can_return)
 
func set_type(value):
	type = value
	print("Type set to: ", type)
 
func set_texture(texture):
	$Sprite2D.texture = texture
	print("Texture set")
 
 
#func _quadratic_bezier() -> Vector2:
	#var q0: Vector2 = p0.lerp(p1, t)
	#var q1: Vector2 = p1.lerp(p2, t)
	#return q0.lerp(q1, t)
 
 
func _physics_process(delta):
	print("Physics process: t = ", t, " returning = ", returning, " can_return = ", can_return)
	p0 = get_tree().current_scene.find_child("Player").global_position
 
	if not returning:
		if t < 1.0:
			t += speed * delta
 
			if can_return and t >= 0.5:
				returning = true
		elif t>= 1.0:
			queue_free()
	else:
		if t >= 0:
			t -= speed * delta
 
			if t <= 0.0:
				queue_free()
 
	position = position.bezier_interpolate(p0,p1,p2,t)
 
	if enemy != null:
		enemy.position = position

func set_ignore_body(body):
	ignore_body = body
	print("Ignore body set to: ", body.name)
	
func _on_body_entered(body):
	if body == ignore_body or body.is_in_group("Terrain"):
		return
	if type == "Hook":
		enemy = body
		returning = true
		print("Hook hit enemy: ", enemy.name)
		#return
 
	#body.take_damage()
