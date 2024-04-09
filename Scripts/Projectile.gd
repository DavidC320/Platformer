extends CharacterBody2D

@export var projectile_data:ProjectileResource

var x_direction := 1
var floor_bounce_count := 0
var wall_bounce_count := 0

var gravity:int
var rebound:int
var speed:int


func count_bounce(current_bounce_count:int, max_bounce_count:int):
	if current_bounce_count >= max_bounce_count and max_bounce_count != -1:
		queue_free()


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += projectile_data.gravity * delta
	else:  # Bounce
		floor_bounce_count += 1
		count_bounce(floor_bounce_count, projectile_data.floor_bounce_count)
		velocity.y = projectile_data.rebound
	if is_on_wall():
		wall_bounce_count += 1
		count_bounce(wall_bounce_count, projectile_data.wall_bounce_count)
		x_direction *= -1

	velocity.x = x_direction * projectile_data.speed

	move_and_slide()


func _on_enemy_detector_body_entered(body):
	body.damage()
	queue_free()
