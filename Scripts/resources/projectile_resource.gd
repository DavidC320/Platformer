extends Resource
class_name ProjectileResource

@export_category("Info")
@export var projectile_name := "Null"
@export var description := "None"
@export var only_make_big := false
@export_category("Stats")
@export var gravity := 2080
@export var damage := 1
@export_range(0, 1000) var speed := 300
@export_range(-1000, 0) var rebound := -350.0
@export_range(-1, 100) var floor_bounce_count := -1
@export_range(-1, 100) var wall_bounce_count := 1
@export_category("Sprites")
@export var projectile_texture:Texture2D
@export_category("Item Data")
@export var item_texture:Texture2D
@export var item_speed := 300.0
