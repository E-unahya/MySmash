extends RigidBody3D

@onready var attack_area : AttackArea = $AttackArea

var entered : bool = false
var in_area_body : CharacterBody3D = null
# チーム戦になった場合、どう分けるのか不明！
## 所持者、持ったファイターではないという判定を何を持って決めるのか
var fighter_name : String
## 誰かに持たれている感じですか？
var has_figher : bool
## ぶん投げましたか？そうであればダメージが入ります。
var throwed : bool
## 持ってた人の手の位置

func _ready():
	fighter_name = ""
	throwed = false
	has_figher = false

func _physics_process(delta):
	## 手に持っている状態だったら常にプレイヤーの目の前にアイテムがセットされる。
	if in_area_body and freeze:
		if in_area_body is SandBack:
			return
		PhysicsServer3D.body_set_state(
			get_rid(),
			PhysicsServer3D.BODY_STATE_TRANSFORM,
			Transform3D.IDENTITY.translated(in_area_body.item_hand_midium.position)
		)

func _input(event):
	if event.is_action_pressed("Shield"):
		freeze = false
		## これに何かもう一つ条件を付け加えて地面に落ちててファイターが持ってないことを知らせる方法
		if in_area_body != null and has_figher:
			reparent(in_area_body.owner)
			## 投げる方向
			var throw_vec = in_area_body.character_direction * Vector3(0, 0, -500)
			throw_vec += Vector3(0, 500, 0)
			apply_central_force(throw_vec)
			throwed = true
		has_figher = false
	if entered:
		if event.is_action_pressed("JabAttack") and in_area_body != null and in_area_body.has_node("Character/ItemHandMidium"):
			reparent(in_area_body.item_hand_midium)
			freeze = true
			rotate(Vector3.ZERO, 0)
			## これだと持った瞬間にアニメーションが再生されてしまう。
			if has_figher:
				if has_node("AnimationPlayer"):
					$AnimationPlayer.play(get_meta("animation_name", "RESET"))
			# このタイミングで持っていますアピールを行う。
			has_figher = true


func _on_area_3d_body_entered(body):
	## ファイターってグループだったら持てる。
	if body.is_in_group("Fighter"):
		entered = true
		has_figher = true
		in_area_body = body
		if !throwed:
			fighter_name = body.name


func _on_area_3d_body_exited(body):
	if body.is_in_group("Fighter"):
		reparent(in_area_body.owner)
		entered = false
		has_figher = false
		## ここにNULLを設定する処理を入れると色々面倒
		# in_area_body = null


func _on_attack_area_body_entered(body):
	# 前提として相手がダメージメソッドを持ってないといけない
	if body.name != fighter_name and throwed and in_area_body != null:
		if body.has_method("damage"):
			print("Damage")
			body.damage(attack_area.attack_pt, attack_area.futtobi_vec * in_area_body.character_direction)
			throwed = false


## Aぼたんを押したら持っているアイテム固有のアニメーションとか再生してほしい
func _shot():
	"""
	普通に弾丸を放つメソッド
	"""
	var bullet = preload("res://Assets/Item/Bullet.tscn").instantiate()
	bullet.scale = Vector3(0.5, 0.5, 0.5)
	add_child(bullet)


func _on_visible_on_screen_notifier_3d_screen_exited():
	print("FREE")
	queue_free()
