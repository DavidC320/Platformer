extends Node2D
class_name InteractiveBlock

@export var disable_left := true
@export var disable_right := false

@onready var left_mover := $LeftMover
@onready var right_mover := $RightMover

func _physics_process(delta):
	if left_mover.get_overlapping_bodies().size() > 0 and !disable_left:
		var player = right_mover.get_overlapping_bodies()[0]
		move_camera(true, player.velocity, player.velocity.x, delta)

	elif right_mover.get_overlapping_bodies().size() > 0 and !disable_right:
		var player = right_mover.get_overlapping_bodies()[0]
		move_camera(false, player.velocity, player.SPEED, delta)


func move_camera(direction_left:bool, velocity:Vector2, speed:float, delta):
	var sets_of_checks = {
		true : velocity.x < 0,
		false : velocity.x > 0
	}
	if sets_of_checks.get(direction_left):
		position.x += velocity.x * delta
	pass
