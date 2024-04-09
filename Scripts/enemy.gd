extends CharacterBody2D
class_name EnemyBase


const SPEED = 75.0
const JUMP_VELOCITY = -400.0

var move_velocity:= -1
@export var health := 1
var dead = false

@onready var collison_shape := $CollisionShape2D

@onready var left_ground_ray := $LeftGroundCheck
@onready var right_ground_ray := $RightGroundCheck

@onready var animated_sprite := $AnimatedSprite2D
@onready var hurt_sound := $hurt_sound


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	velocity.x = move_velocity * SPEED 

	if dead and !collison_shape.disabled:
		collison_shape.disabled = true

	move_and_slide()


func _on_right_ground_area_body_entered(_body:Node2D):
	move_velocity = -1
	animated_sprite.flip_h = false


func _on_left_ground_area_body_entered(_body:Node2D):
	move_velocity = 1
	animated_sprite.flip_h = true

func check_rays():
	if left_ground_ray.is_colliding():
		move_velocity = 1
	elif right_ground_ray.is_colliding():
		move_velocity = -1

func damage():
	health -= 1
	hurt_sound.play()
	if health <= 0:
		SCORE.add_score(1)
		dead = true
		animated_sprite.play("dead")

func _on_kill_box_body_entered(body:Node2D):
	if body.velocity.y > 0:
		body.bounce()
		damage()


func _on_animated_sprite_2d_animation_finished():
	if dead:
		queue_free()
