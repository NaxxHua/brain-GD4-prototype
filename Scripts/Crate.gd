extends StaticBody2D  # 继承自StaticBody2D，表示这是一个不会自主移动的物体

var health = 3  # 初始化箱子的生命值为3

# 当与箱子相交的区域被其他区域碰触时调用
func _on_hitbox_area_entered(area):
	if area.name == "Sword":  # 检查进入的区域是否为“Sword”（假设这是玩家的剑）
		$anim.play("Hurt")  # 播放受伤动画
		health -= 1  # 生命值减1
		await $anim.animation_finished  # 等待受伤动画播放完成
		if health > 0:
			$anim.play("Active")  # 如果还有生命值，播放活动状态的动画
		else:
			$anim.play("Destroyed")  # 如果生命值为0，播放被摧毁的动画
			await $anim.animation_finished  # 等待摧毁动画播放完成
			queue_free()  # 从场景中移除这个节点
