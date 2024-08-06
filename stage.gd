extends Node3D

@onready var fighters = $Fighters
@export var select_fighters : Array[Resource]


func _ready():
	# ほんとだったらあらかじめ選ばれたファイターが子として追加されるのだが
	# 追加されたファイターにそれぞれのキーコンフィグを導入する。
	var fighers_array = fighters.get_children()
	for f in len(fighers_array):
		fighers_array[f].player_index = f
	# ゲームパッドがどれくらい接続されているのか把握できる。

