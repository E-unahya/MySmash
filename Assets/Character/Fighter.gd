extends CharacterBody3D

class_name Fighter

@onready var action_player: AnimationPlayer = $ActionPlayer
@onready var attack_area: Area3D = $AttackArea
## キャラクターの体の部分
@onready var character = $Character
@onready var item_hand_midium = $Character/ItemHandMidium
## キャラクターがどこを向いているのか取得するための変数
var character_direction : int

@export var SPEED = 5.0
@export var JUMP_VELOCITY = 5.0
@export var FUKKI_VELOCITY = 7

## やや面倒だけどexportで入力を受け付ける方法
@export var player_index : int = 0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var double_jump : bool = false
var fukki_used : bool = false

## 崖つかみ状態であるか否か
var is_not_gake : bool = true

func _is_up() -> float:
	return Input.get_joy_axis(player_index, JOY_AXIS_LEFT_Y)

func _is_axis_x() -> float:
	return Input.get_joy_axis(player_index, JOY_AXIS_LEFT_X)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		fukki_used = false

	# Handle jump.
	if _is_up() <= -0.7 and is_on_floor():
		velocity.y = JUMP_VELOCITY
		double_jump = true
	## ダブルジャンプの場所、追々解決する
	if _is_up() <= -0.5 and double_jump and !is_on_floor():
		velocity.y = JUMP_VELOCITY
		double_jump = false
	# xだけどあのゲームの縦担当
	var input_dir_x := Input.get_joy_axis(player_index, JOY_AXIS_LEFT_Y)
	# yだけどあのゲームの横移動担当
	var input_dir_y := Input.get_joy_axis(player_index, JOY_AXIS_LEFT_X)

	# 復帰技を仕掛ける
	if Input.get_joy_axis(player_index, JOY_AXIS_LEFT_Y) <= -0.7 and input_dir_x > 0 and !fukki_used:
		fukki_used = true
		velocity.y = FUKKI_VELOCITY
	var direction := (transform.basis * Vector3(input_dir_x, 0, input_dir_y)).normalized()
	if direction:
		velocity.z = -direction.z * SPEED
	else:
		velocity.z = move_toward(velocity.z, 0, SPEED)


func _input(event):
	## ここから技関係の入力に入る
	# 普通のパンチ
	if Input.is_joy_button_pressed(player_index, JOY_BUTTON_B):
		action_player.play("Jab")
	## 復帰技
	if Input.is_joy_button_pressed(player_index, JOY_BUTTON_B) and !fukki_used:
		action_player.play("FukkiWaza")
	# 崖に捕まっているトキのアクション
	if !is_not_gake:
		if _is_up() <= -0.7:
			set_check_gake_tukami(true)
			velocity.y = JUMP_VELOCITY * 2
			double_jump = true
			fukki_used = false
	if _is_up() <= -0.7:
		action_player.play("Jump")
	if Input.get_joy_axis(player_index, JOY_AXIS_LEFT_X) >= 0.7:
		character.look_at(position + Vector3(0,0,1))
		character_direction = 1
	if Input.get_joy_axis(player_index, JOY_AXIS_LEFT_X) <= -0.7:
		character.look_at(position + Vector3(0,0,-1))
		character_direction = -1

	move_and_slide()


# ここから攻撃などのサブメソッド
func attack(atari_hantei_node:String) -> void:
	#　当たり判定のエリアを取得
	var atari_hantei : AttackArea = get_node(atari_hantei_node)
	var enemies = atari_hantei.get_overlapping_bodies()
	for enemy in enemies:
		if enemy.has_method("damage"):
			enemy.damage(atari_hantei.attack_pt, atari_hantei.futtobi_vec * character_direction)


func set_check_gake_tukami(boolean : bool) -> void:
	is_not_gake = boolean
	set_physics_process(boolean)
	# set_process(boolean)


func _on_action_player_animation_changed(old_name, new_name):
	print(old_name)
	print(new_name)
