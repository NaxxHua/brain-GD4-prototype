extends StaticBody2D  # 继承自StaticBody2D，表示这是一个不动的物体

# 当有物体进入平台的区域时，这个函数会被调用
func _on_area_2d_body_entered(body):
	if body.name == "Player":  # 检查进入区域的物体是否是玩家
		$anim.play("Destroyed")  # 播放被摧毁的动画
		await $anim.animation_finished  # 等待摧毁动画播放完成
		$anim.play("Respawn")  # 播放重新出现的动画
