extends Skill
class_name Tornado

func _init(target):
	cooldown = 7.0
	texture = preload("res://Sprites/Spells/48x48/skill_icons24.png")
	animation_name = "Tornado"
	
	super._init(target)
	
func cast_spell(target):
	super.cast_spell(target)
	target.single_shot(animation_name)
