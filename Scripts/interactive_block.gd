@tool
extends StaticBody2D
class_name InteractableObject

const tile_size := 10

@export var has_been_hit:= false
@export var points := 1
@export var candy := 0
@export_category("Textures")
@export var non_hit_atlas:= Vector2(0, 0)
@export var hit_atlas:= Vector2(1, 0)
@export_category("special")
@export var check_if_large:= true
@export var invisible_non_hit:= false
@export var destroy_block_on_hit:= false
@export var power_up:ProjectileResource
@export var count_till_switch := 1
@export var give_score_on_hits := false
var count := 0

# Nodes
@onready var collison_cube := $CollisionShape2D
@onready var collison_box := $HitBox
@onready var sprite := $Sprites/Sprite2D
@onready var candy_sprite := $Sprites/Sprite2D2
@onready var animation_player := $AnimationPlayer
@onready var preload_powerup = preload("res://Scenes/PowerUp.tscn")

@onready var break_sfx := $Break
@onready var coin_sfx := $Coin
@onready var powerup_sfx := $Powerup

var change_collison := false

func _ready():
	change_sprite(non_hit_atlas)
	if invisible_non_hit:
		sprite.visible = false
		candy_sprite.visible = false
		collison_cube.disabled = true


func change_sprite(atlas:Vector2):
	var new_atlas := AtlasTexture.new()
	var formated_atlas := atlas * tile_size
	var formated_tile_size := Vector2.ONE * tile_size
	new_atlas.region = Rect2(formated_atlas, formated_tile_size)

	var texture_sprite := load("res://Assets/Tilesets/Blocks.png")
	new_atlas.atlas = texture_sprite
	sprite.texture = new_atlas


func block_was_hit():
	if power_up:
		var new_powerup = preload_powerup.instantiate()
		new_powerup.projectile_data = power_up
		add_child(new_powerup)
		new_powerup.position = global_position + Vector2(20, -16)
		new_powerup.top_level = true
		print("created")
	if count == count_till_switch:
		if !destroy_block_on_hit:
			if power_up:
				powerup_sfx.play()
			else:
				coin_sfx.play()
			change_sprite(hit_atlas)
			collison_cube.disabled = false
		else:
			break_sfx.play()
			collison_cube.disabled = true
			collison_box.disable_mode = false
			sprite.visible = false
	else:
		has_been_hit = false

		


func _on_hit_box_body_entered(_body:Node2D):
	if !has_been_hit and _body.velocity.y < 0 and (_body.large or !check_if_large):
		count += 1
		change_collison = true
		sprite.visible = true
		if (count == count_till_switch) or give_score_on_hits:
			SCORE.add_score(points)
			candy_sprite.visible = true if candy > 0 and power_up == null else false
			SCORE.add_candy(candy)
		has_been_hit = true
		animation_player.play("hit")
