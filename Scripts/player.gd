extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0
# https://youtu.be/IOe1aGY6hXA?si=htJtFo95xkavGaIS
# How to make the jump better
@export var jump_height:int = -600
@export var time_to_peak:float
@export var time_to_descent:float

# I should watch the GDC talk about this
@onready var jump_velocity : float = ((2.0 * jump_height) / time_to_peak) * -1
@onready var jump_gravity : float = ((-2.0 * jump_height) / (time_to_peak ** 2)) * -1
@onready var fall_gravity : float = ((-2.0 * jump_height) / (time_to_descent ** 2)) * -1

@export var large = false
var dead = false
var firing = false
@export var power_up:ProjectileResource
var direction = 1
var acceleration := Vector2.ZERO

@onready var cayote_timer = $CayoteTimer
@onready var invincible_timer := $Invencible
@onready var jump_sfx := $AudioStreamPlayer
@onready var hurt_sfx := $AudioStreamPlayer2
@onready var projectile_mark := $ProjectileMark
@onready var preloaded_projectile = preload("res://Scenes/Projectile.tscn")
@onready var rubber_ball_material = preload("res://Assets/Materials/RubberBall.tres")

@onready var animations = {
	false : [$Small, $CollisonSmall, $HurtBox/CollisonSmall],
	true : [$Large, $CollisonLarge, $HurtBox/CollisonLarge]
}

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var cayote := false
var can_cayote := false
var change_sprites = false

#
var camera:Node2D
var kill_point:Marker2D

func _ready():
	camera = get_tree().get_first_node_in_group("camera")
	kill_point = get_tree().get_first_node_in_group("Death Point")
	character_state_changed()

func character_state_changed():
	var game_state = animations.get(large)
	var previous_game_state = animations.get(!large)

	# in use
	game_state[0].visible = true
	for collison in [game_state[1], game_state[2]]:
		collison.disabled = false
	# not in use
	previous_game_state[0].visible = false
	for collison in [previous_game_state[1], previous_game_state[2]]:
		collison.disabled = true


func _input(event):
	if event.is_action_pressed("fire projectile") and power_up != null:
		var new_projectile =preloaded_projectile.instantiate()
		new_projectile.projectile_data = power_up
		new_projectile.x_direction = direction+ clamp(velocity.x,-1, 1)
		projectile_mark.add_child(new_projectile)
		new_projectile.top_level = true
		new_projectile.global_position = projectile_mark.global_position


func _process(_delta):
	var animation: AnimatedSprite2D = animations.get(large)[0]

	if velocity.x > 0:
		direction = 1
		animation.scale.x = 4
		projectile_mark.position.x = 17
	elif velocity.x < 0:
		direction = -1
		animation.scale.x = -4
		projectile_mark.position.x = -17
	
	if Input.is_action_just_pressed("fire projectile") and large and power_up:
		animation.play("powerup")
		firing = true
	if !firing:
		if velocity == Vector2.ZERO and is_on_floor():
			animation.play("default")
		elif velocity.y != 0:
			animation.play("jump")
		elif velocity.x != 0:
			animation.play("walk")


func get_gravity():
	return jump_gravity if velocity.y < 0.0 else fall_gravity


func _physics_process(delta):
	if global_position.y > kill_point.global_position.y:
			SCORE.player_died()
 
	if change_sprites:
		change_sprites = false
		character_state_changed()
	
	# Add the gravity.
	if not is_on_floor() and cayote_timer.is_stopped():
		velocity.y += get_gravity() * delta
			
		if !cayote and can_cayote:
			cayote = true
			cayote_timer.start()
	else:
		can_cayote = true
			

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or !cayote_timer.is_stopped()):
		velocity.y = jump_velocity
		cayote = false
		can_cayote = false
		cayote_timer.stop()
		jump_sfx.play()
	# https://youtu.be/eXmx3SQ_wBo?si=BTcVOzAoUFpPXjSn
	elif Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = fall_gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# https://youtu.be/jF1mnftlB-Q?si=rvTFzm_gTO8EC73k
	# Code taken from DevWorm
	if Input.is_action_pressed("left"):
		velocity.x = max(velocity.x - 20, -SPEED)
	elif Input.is_action_pressed("right"):
		velocity.x = min(velocity.x + 20, SPEED)
	else:
		if velocity.x < .1 and velocity.x > -.1:
			velocity.x = 0
		velocity.x = lerp(velocity.x, 0.0, 0.25)
	move_and_slide()


func _on_cayote_timer_timeout():
	cayote_timer.stop()

func bounce():
	can_cayote = false
	velocity.y = jump_velocity


func _on_hurt_box_body_entered(body:Node2D):
	if body is EnemyBase and velocity.y >= 0:
		print(velocity.y)
		hurt_sfx.play()
		if invincible_timer.is_stopped():
			if power_up:
				power_up = null
				animations.get(true)[0].material = null
				invincible_timer.start()
			
			elif large == true:
				large = false
				invincible_timer.start()
				change_sprites = true

			elif large == false:
				SCORE.player_died()
	
	elif body is PowerUp:
		large = true
		change_sprites = true
		if !body.projectile_data.only_make_big:
			power_up = body.projectile_data
			animations.get(true)[0].material = rubber_ball_material
		body.queue_free()


func _on_invencible_timeout():
	cayote = false
	invincible_timer.stop()


func _on_large_animation_finished():
	var animation: AnimatedSprite2D = animations.get(large)[0]
	if animation.animation == "powerup":
		firing = false
