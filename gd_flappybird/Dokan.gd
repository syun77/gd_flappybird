extends StaticBody2D

# 移動速度
var velocity = Vector2(-150, 0)

func start(pos:Vector2, speed_rate:float) -> void:
	position = pos
	velocity *= speed_rate

func _process(delta:float) -> void:
	# 位置に速度を足し込む
	position += velocity * delta
	if position.x < -128:
		# 画面外に出たら消える
		queue_free()
