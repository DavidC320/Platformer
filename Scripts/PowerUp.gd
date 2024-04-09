extends CharacterBody2D
class_name PowerUp

@export var projectile_data:ProjectileResource

var move_velocity:= 1

var speed := 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	speed = projectile_data.item_speed


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	velocity.x = move_velocity * speed

	move_and_slide()


func _on_right_ground_area_body_entered(_body:Node2D):
	move_velocity = -1


func _on_left_ground_area_body_entered(_body:Node2D):
	move_velocity = 1
