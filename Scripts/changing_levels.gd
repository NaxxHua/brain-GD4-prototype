extends Area2D  # 继承自Area2D，通常用于碰撞检测和区域监测

# 当一个物体进入这个区域时，这个函数被调用
func _on_body_entered(body):
	if body.name == "Player":  # 检查进入区域的是不是名为"Player"的物体
		get_tree().change_scene_to_file("res://Scenes/level2.tscn")  # 改变当前场景到指定的关卡场景
