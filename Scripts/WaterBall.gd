extends Skill
class_name WaterBall

func _init(target):
	cooldown = 2.0
	texture = preload("res://Sprites/Spells/48x48/skill_icons48.png")
	animation_name = "Water"
	
	super._init(target)
	
func cast_spell(target):
	super.cast_spell(target)
	target.multi_shot(5, 0.1, animation_name)
