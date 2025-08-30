extends CharacterBody2D

# 重力
const GRAVITY_POWER := 1000

# ジャンプ力
const JUMP_POWER := -400

# ジャンプできるかどうか
var _can_jump := true

# スプライト
@onready var _sprite = $Sprite

func _process(delta) -> void:
	# 移動処理を行う
	_update_moving(delta)
	
	# 衝突処理
	_update_collision(delta)
	
	# アニメーションの更新
	_update_anim(delta)
	
	if position.x < 0 or position.y > 480:
		# 画面外に出たら消滅
		queue_free()

# 移動処理を行う
func _update_moving(delta:float) -> void:	
	# 重力を加算
	velocity.y += GRAVITY_POWER * delta
	
	if _can_jump and Input.is_action_just_pressed("ui_accept"):
		# Spaceキーでジャンプ処理
		velocity.y = JUMP_POWER
		
	if position.y < 0:
		# 画面上にはみ出さないようにする
		velocity.y = 100
		
	if position.y > 600-64:
		# 画面下に落ちないようにオートジャンプ
		velocity.y = JUMP_POWER

# 衝突処理を行う
func _update_collision(delta:float) -> void:
	# 移動と衝突処理を行う
	var collision = move_and_collide(velocity * delta)
	if collision:
		# 衝突したのでジャンプできなくする
		_can_jump = false
		# 左方向に吹き飛ばす
		velocity.x -= 300
		if position.y < collision.get_position().y:
			# ドカンよりも上にプレイヤーがいる
			velocity.y = -300 # 上にバウンド
		else:
			# ドカンよりも下にプレイヤーがいる.
			velocity.y = 300 # 下にバウンド
		# さらに移動量を加える.
		move_and_collide(velocity * delta)
	
# アニメーションの更新
func _update_anim(delta:float) -> void:
	# 基本
	_sprite.frame = 0
	if velocity.y < 0:
		# 上昇中
		_sprite.frame = 1
	if _can_jump == false:
		# 吹っ飛び中は回転する
		_sprite.rotation -= 10 * delta
		# ダメージ画像にする
		_sprite.frame = 2
