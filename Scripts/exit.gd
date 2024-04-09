extends Node2D


@onready var sprite := $Sprite2D
@onready var label := $Label

func _ready():
	SCORE.candy_updated.connect(check)

func check(candy):
	if candy >= 10:
		label.text = "%d / 10" % candy
		sprite.play("Open")
	else:
		print(candy)
		label.text = "%d / 10\nNot enough candy\ntry again." % candy

func _on_area_2d_body_entered(body:Node2D):
	if SCORE.candy < 10:
		SCORE.player_died()
	else:
		get_tree().change_scene_to_file("res://Scenes/Menues/Outro.tscn")
