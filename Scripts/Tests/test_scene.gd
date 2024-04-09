extends Node2D

@export var projectile_resource:ProjectileResource

@onready var marker_2d = $Marker2D
@onready var projectile = preload("res://Scenes/Projectile.tscn")

func _on_button_pressed():
	var created_projectile = projectile.instantiate()
	created_projectile.projectile_data = projectile_resource
	marker_2d.add_child(created_projectile)
