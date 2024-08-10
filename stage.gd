extends Node3D

@onready var fighters = $Fighters
@onready var life_container = $UI/LifeContainer

# より厳格にシーンをチョイスできるように
@export var select_fighters : Array[PackedScene]

func _ready():
	# ほんとだったらあらかじめ選ばれたファイターが子として追加されるのだが
	# 追加されたファイターにそれぞれのキーコンフィグを導入する。
	for i in life_container.get_children():
		i.queue_free()
	var parcentage = preload("res://Assets/Parcentage.tscn").instantiate()
	for f in select_fighters:
		f.connect("damaged", parcentage._on_sand_back_damaged)
		life_container.add_child(parcentage)
	var fighers_array = fighters.get_children()
	for f in len(fighers_array):
		fighers_array[f].player_index = f
	# ゲームパッドがどれくらい接続されているのか把握できる。
