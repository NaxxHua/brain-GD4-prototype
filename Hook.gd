extends SkillCurved
class_name Hook
 
var distance : Array[float]
var angle : Array[float]
var can_return : Array[bool]
 
var count : int
var texture : Texture2D
 
func _init(target, slot):
	icon = preload("res://assets/pudge_meat_hook.png")
	type = "Hook"
	texture = load("res://assets/hook.png")
 
	super._init(target,slot)
 
	count = 1
 
	distance = [300]
	angle = [0]
	can_return = [true]
