extends SkillCurved

class_name WildAxes
 
var distance : Array[float]
var angle : Array[float]
var can_return : Array[bool]
 
var count : int
var texture : Texture2D
 
func _init(target, slot):
	icon = preload("res://assets/beastmaster_wild_axes.png")
	type = "Projectile"
	texture = load("res://assets/Axe.png")
 
	super._init(target,slot)
 
	count = 2
 
	distance = [125,125]
	angle = [60,-60]
	can_return = [true, true]
