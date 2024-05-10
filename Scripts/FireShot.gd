extends Skill
class_name FireShot

func _init(target):
	cooldown = 1.0
	animation_name = "Fire"
	texture = preload("res://Sprites/Spells/48x48/skill_icons4.png")
	
	super._init(target)
	

func cast_spell(target):
	super.cast_spell(target)
	target.multi_shot()
