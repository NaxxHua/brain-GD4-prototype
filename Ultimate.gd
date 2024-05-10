extends Skill
class_name Ultimate

func _init(target):
	cooldown = 30.0
	texture = preload("res://Sprites/Spells/48x48/skill_icons13.png")
	animation_name = "Ultimate"
	
	super._init(target)
	
func cast_spell(target):
	super.cast_spell(target)
	target.radial(32)
