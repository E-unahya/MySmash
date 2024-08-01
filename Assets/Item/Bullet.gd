extends Area3D


func _process(delta):
	self.position.z -= 100 * delta


## 例えば一発当たったら消えるタイプの弾丸とか
func _on_body_entered(body):
	## 玉が当たったときに何かしらダメージが欲しい
	if body.has_method("damage"):
		body.damage(10, Vector3(0, 0, -1))

