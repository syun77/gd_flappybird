extends Node2D

# 土管オブジェクト
var DOKAN_OBJ = preload("res://Dokan.tscn")

# 出現間隔(最初は3秒)
var interval = 3

# 生成タイマー
var timer = interval

# 土管出現回数
var dokan_cnt = 0

# キャプション
@onready var caption = $CanvasLayer/Caption

# プレイヤー
@onready var player = $Player

func _ready():
	# 乱数を初期化
	randomize()
	
	# キャプションは初期状態では非表示にしておく
	caption.visible = false

func _process(delta):
	timer += delta
	if timer > interval:
		# インターバルを超えたら土管を出現させる
		timer -= interval
		_add_dokan()
		
	if is_instance_valid(player) == false:
		# プレイヤーが消滅した
		# キャプションを更新
		caption.visible = true
		caption.text = "GAME OVER\n\n RETRY: DOWN KEY"
		
		# 下キーが押されたらリトライ
		if Input.is_action_just_pressed("ui_down"):
			# Mainシーンを読み込み直してリトライする
			get_tree().change_scene_to_file("res://Main.tscn")

func _add_dokan():
	# 出現回数をカウントアップ
	dokan_cnt += 1

	# 高さを決める
	var xbase = 800 + 120
	var ybase = randf_range(32, 400-32)
	
	# 土管を上下に生成
	for i in range(2):
		var dokan = DOKAN_OBJ.instantiate()
		var py = ybase
		if i == 0:
			# 上のドカン
			py += -320
		else:
			# 下のドカン
			py += 320 + 160

		# 土管の出現回数が増えるとスピードアップ
		var speed_rate = 1 + 0.5 * dokan_cnt
		dokan.start(Vector2(xbase, py), speed_rate)
		add_child(dokan)
	
	# インターバルを減らす
	interval = max(0.5, interval-0.2)
