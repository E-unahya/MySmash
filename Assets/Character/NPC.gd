extends CharacterBody3D

class_name SandBack

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var player_index : int = 0

@onready var animation_player = $AnimationPlayer
@onready var character = $Enemy

signal damaged(damage_num : float)

var life_parcentage : float
var character_direction : int

func _ready():
	life_parcentage = 0
	character_direction = -1

func damage(attack_pt, futtobi_vec):
	life_parcentage += attack_pt
	velocity += futtobi_vec * life_parcentage * character_direction
	animation_player.play("damage")
	damaged.emit(life_parcentage)
	move_and_slide()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()

func _on_animation_player_animation_finished(anim_name):
	animation_player.stop()

func set_check_gake_tukami(hoge:bool):
	pass
