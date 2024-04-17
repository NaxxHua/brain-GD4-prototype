extends Area2D  # 继承自Area2D，通常用于监测2D区域内的碰撞和重叠

# 当有物体进入这个区域时，这个函数被调用
func _on_body_entered(body):
	if body.name == "Player":  # 检查进入区域的物体是否是玩家
		Globals.playerCoin += 1  # 增加全局变量中的玩家金币计数
		$anim.play("Picked")  # 播放拾取动画
		await $anim.animation_finished  # 等待动画播放完成
		queue_free()  # 从场景中移除这个金币节点
