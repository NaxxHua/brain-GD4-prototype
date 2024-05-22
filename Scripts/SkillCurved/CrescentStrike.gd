extends SkillCurved
class_name CrescentStrike
 
var distance : Array[float]
var angle : Array[float]
var can_return : Array[bool]
 
var count : int
var texture : Texture2D
 
func _init(target, slot):
	icon = preload("res://assets/Diana_Crescent_Strike.png")
	type = "Projectile"
	texture = load("res://assets/bomb.png")
 
	super._init(target,slot)
 
	count = 1
 
	distance = [240]
	angle = [60]
	can_return = [false]
