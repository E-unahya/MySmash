extends Node3D

@onready var fighters = $Fighters
@onready var life_container = $UI/LifeContainer

@onready var timer = $Timer

# より厳格にシーンをチョイスできるように
@export var select_fighters : Array[PackedScene]
@export var position_array : Array[Vector3]

## ここにアイテムを落とす処理を入れる。タイムアウトを利用する。

func timer_init() -> void:
	randomize()
	timer.wait_time = randf_range(2, 5)


func _ready():
	# ほんとだったらあらかじめ選ばれたファイターが子として追加されるのだが
	# 追加されたファイターにそれぞれのキーコンフィグを導入する。
	for i in life_container.get_children():
		i.queue_free()
	var parcentage = preload("res://Assets/Parcentage.tscn")
	for f in select_fighters:
		var parcentage_instantiate = parcentage.instantiate()
		var fighter = f.instantiate()
		fighter.connect("damaged", parcentage_instantiate._on_sand_back_damaged)
		life_container.add_child(parcentage.instantiate())
		fighters.add_child(fighter)
	var fighers_array = fighters.get_children()
	# 接続されているゲームパッドを取得
	var get_joypads = Input.get_connected_joypads()
	for f in len(fighers_array):
		if get_joypads.is_empty() == false:
			fighers_array[ f ].player_index = get_joypads.pop_front()
		if position_array.is_empty() == false:
			fighers_array[ f ].position = position_array.pop_front()
			# ステージの初期位置によって向きを変更する。
			if fighers_array[f].position.z < 0:
				fighers_array[f].character_look_at(-1)
			else:
				fighers_array[f].character_look_at(1)
	timer_init()
	timer.start()


func _on_timer_timeout():
	var items : Array[PackedScene] = [
		preload("res://Assets/Item/Blaster.tscn"),
		preload("res://Assets/Item/Cube.tscn"),
		preload("res://Assets/Item/Knife.tscn"),
	]
	## pick_randomでパックしたシーンを1つ適当に選ぶ
	var i = items.pick_random().instantiate()
	## TODO 範囲を何かしらの基準で決める
	i.position = Vector3(0, 10, randf_range(-10, 10))
	add_child(i)
	print(i.name + "has been add_child.")
	timer_init()
