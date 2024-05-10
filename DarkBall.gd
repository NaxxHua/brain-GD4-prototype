extends Skill
class_name DarkBall

func _init(target):
	cooldown = 2.0
	texture = preload("res://Sprites/Spells/48x48/skill_icons29.png")
	animation_name = "Dark"
	
	super._init(target)
	
func cast_spell(target):
	super.cast_spell(target)
	target.multi_shot(4, 0.2, animation_name)
