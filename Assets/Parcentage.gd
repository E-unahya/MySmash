extends TextureRect
@onready var parcentage_label = $ParcentageLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	parcentage_label.text = str(0.00) + "%"


func _on_sand_back_damaged(damage_num):
	parcentage_label.text = str("%0.2f" % damage_num) + "%"
