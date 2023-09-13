extends StaticBody2D

class_name Dokan

var velocity = Vector2(-150, 0)

# 開始処理
func start(pos, speed_rate):
	position = pos
	velocity *= speed_rate

func _process(delta):
	position += velocity * delta
	if position.x < -128:
		# 画面外に出たら消える
		queue_free()
