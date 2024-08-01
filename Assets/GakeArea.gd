extends Area3D

class_name GakeArea3D



func _on_body_entered(body):
	if body.is_in_group("Fighter"):
		# body.look_at(self.position)
		# どうやって振り向かせるのかがわからない
		body.character.look_at(Vector3.ZERO, Vector3.UP, true)
		body.position = Vector3(self.position.x, self.position.y - 2, self.position.z)
		body.set_check_gake_tukami(false)
		body.action_player.play("GakeTukamiAction")
